// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Interface ERC20 standard d'OpenZeppelin.
// Elle permet d'interagir avec un token comme l'USDC.
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// Contrat Ownable d'OpenZeppelin.
// Il permet d'avoir un propriétaire du contrat (owner),
// ici utilisé comme destinataire des paiements.
import "@openzeppelin/contracts/access/Ownable.sol";

contract StableStay is Ownable {

    // Représente une réservation d'hôtel.
    struct Reservation {
        address guest;         // Adresse du client qui réserve
        string hotelName;      // Nom de l'hôtel
        string roomType; // Type de chambre (Single, Double, Suite)
        uint256 checkInDate;   // Date d'arrivée (timestamp)
        uint256 checkOutDate;  // Date de départ (timestamp)
        uint256 amount;        // Montant à payer en USDC
        bool paid;             // Indique si la réservation est déjà payée
    }

    // Référence vers le token USDC.
    // On suppose ici qu'on passera au constructeur l'adresse du contrat USDC.
    IERC20 public usdc;

    // Compteur total des réservations.
    // Il sert à générer des IDs 1, 2, 3, ...
    uint256 public reservationCount;

    // Mapping qui permet de retrouver une réservation à partir de son ID.
    mapping(uint256 => Reservation) public reservations;

    // Event émis lorsqu'une réservation est créée.
    event ReservationCreated(
        uint256 reservationId,
        address guest,
        string hotelName,
        string roomType,
        uint256 amount
    );

    // Event émis lorsqu'une réservation est payée.
    event ReservationPaid(uint256 reservationId);

    // Constructeur exécuté une seule fois au déploiement.
    // _usdc = adresse du contrat USDC sur le réseau utilisé.
    // Ownable(msg.sender) définit le déployeur comme owner du contrat.
    constructor(address _usdc) Ownable(msg.sender) {
        usdc = IERC20(_usdc);
    }

    // Fonction qui crée une nouvelle réservation.
    function createReservation(
        string memory _hotelName,
        string memory _roomType,
        uint256 _checkInDate,
        uint256 _checkOutDate,
        uint256 _amount
    ) external {
        // Vérifie que les dates sont cohérentes.
        require(_checkInDate < _checkOutDate, "Invalid dates");

        // Vérifie que le montant est strictement positif.
        require(_amount > 0, "Invalid amount");

        // Vérifie que les champs texte principaux ne sont pas vides.
        require(bytes(_hotelName).length > 0, "Hotel name required");
        require(bytes(_roomType).length > 0, "Room ID required");

        // Incrémente le compteur pour créer un nouvel ID.
        reservationCount++;

        // Enregistre la réservation dans le mapping.
        reservations[reservationCount] = Reservation({
            guest: msg.sender,
            hotelName: _hotelName,
            roomType: _roomType,
            checkInDate: _checkInDate,
            checkOutDate: _checkOutDate,
            amount: _amount,
            paid: false
        });

        // Émet un event pour informer le frontend / explorateur / logs.
        emit ReservationCreated(
            reservationCount,
            msg.sender,
            _hotelName,
            _roomType,
            _amount
        );
    }

    // Fonction de paiement d'une réservation en USDC.
    function payReservation(uint256 _reservationId) external {
        // Vérifie que l'ID existe bien.
        require(
            _reservationId > 0 && _reservationId <= reservationCount,
            "Invalid reservation"
        );

        // Récupère la réservation en mémoire "storage"
        // pour pouvoir la modifier directement.
        Reservation storage reservation = reservations[_reservationId];

        // Seul le client ayant créé la réservation peut la payer.
        require(reservation.guest == msg.sender, "Not your reservation");

        // Empêche un double paiement.
        require(!reservation.paid, "Already paid");

        // Tente de transférer le montant en USDC depuis le wallet du client
        // vers le propriétaire du contrat.
        //
        // IMPORTANT :
        // Avant d'appeler cette fonction, le client doit d'abord faire
        // un approve USDC sur ce contrat pour autoriser le transfert.
        bool success = usdc.transferFrom(
            msg.sender,
            owner(),
            reservation.amount
        );

        // Vérifie que le transfert a réussi.
        require(success, "USDC payment failed");

        // Marque la réservation comme payée.
        reservation.paid = true;

        // Émet un event.
        emit ReservationPaid(_reservationId);
    }

    // Fonction utilitaire pour lire une réservation.
    function getReservation(uint256 _reservationId)
        external
        view
        returns (Reservation memory)
    {
        require(
            _reservationId > 0 && _reservationId <= reservationCount,
            "Invalid reservation"
        );

        return reservations[_reservationId];
    }
}