SET search_path TO collection_cartes;


-- 1. Utilisateurs
INSERT INTO utilisateur (nom, prenom, email, date_inscription)
VALUES ('Lefebvre', 'Maxime', 'maxime.lef@example.com', '2024-01-15'),
       ('Gagnon', 'Sophie', 'sophie.gagnon@example.com', '2024-02-02'),
       ('Tremblay', 'Alex', 'alex.tremblay@example.com', '2024-03-10'),
       ('Moreau', 'Julie', 'julie.moreau@example.com', '2024-01-28'),
       ('Roy', 'Philippe', 'phil.roy@example.com', '2024-03-20'),
       ('Lambert', 'Karine', 'karine.lambert@example.com', '2024-04-01'),
       ('Dube', 'Martin', 'martin.dube@example.com', '2025-12-11');


-- 2. Raretés (Pokémon + Hockey)
INSERT INTO rarete (nom)
VALUES ('Common'),
       ('Uncommon'),
       ('Rare Holo'),
       ('Ultra Rare'),
       ('Secret Rare'),
       -- Pokemon
       ('Base'),
       ('Gold'),
       ('Clear Cut');
        -- hockey


-- 3. Sets de cartes
INSERT INTO set_carte (nom, annee, editeur)
VALUES ('Pokemon Base Set 1999', 1999, 'Wizards of the Coast'),
       ('Pokemon Scarlet & Violet', 2023, 'Nintendo'),
       ('Tim Hortons 2020-2021', 2020, 'Upper Deck'),
       ('Upper Deck Series 1', 2023, 'Upper Deck'),
       ('Upper Deck Young Guns', 2022, 'Upper Deck');


-- 4. Modèles de cartes (cartes Pokémon + Hockey)
INSERT INTO carte_modele (numero, nom, description, id_set, id_rarete)
VALUES
-- Pokémon Base Set
(4, 'Charizard', 'Fire-type Pokémon', 1, 4),
(7, 'Squirtle', 'Water-type Pokémon', 1, 1),
(1, 'Bulbasaur', 'Grass-type Pokémon', 1, 1),
(15, 'Beedrill', 'Rare insect Pokémon', 1, 3),
(25, 'Pikachu', 'Electric-type Pokémon', 1, 1),

-- Pokémon Scarlet & Violet
(17, 'Fuecoco', 'Fire starter Pokémon', 2, 1),
(21, 'Quaxly', 'Water starter Pokémon', 2, 1),
(55, 'Gardevoir EX', 'Ultra rare EX card', 2, 4),
(88, 'Miraidon', 'Legendary Pokémon', 2, 5),

-- Tim Hortons Hockey
(1, 'Connor McDavid', 'Centre - Edmonton Oilers', 3, 6),
(2, 'Sidney Crosby', 'Centre - Pittsburgh Penguins', 3, 6),
(15, 'Nathan MacKinnon Gold', 'Gold variant', 3, 7),

-- Upper Deck Series 1
(101, 'Auston Matthews', 'Toronto Maple Leafs', 4, 6),
(102, 'Kirill Kaprizov', 'Minnesota Wild', 4, 6),
(150, 'Clear Cut Rookie', 'Clear cut parallel', 4, 8),

-- Young Guns 2022
(201, 'Cole Caufield', 'Montreal Canadiens Rookie', 5, 6),
(202, 'Trevor Zegras', 'Anaheim Ducks Rookie', 5, 6),
(203, 'Spencer Knight', 'Florida Panthers Rookie', 5, 6),
(204, 'Moritz Seider', 'Detroit Red Wings Rookie', 5, 7),
(205, 'Lucas Raymond', 'Detroit Red Wings Rookie', 5, 7);


-- 5. Collections des utilisateurs
INSERT INTO collection (nom, description, id_utilisateur)
VALUES ('Pokémon 1st Gen', 'Collection nostalgique Pokémon 1999', 1),
       ('Hockey Superstars', 'Top NHL players', 2),
       ('Mixed Binder', 'Collection variée Pokémon + Hockey', 3),
       ('Pokémon Modern', 'Cartes récentes Scarlet & Violet', 4),
       ('Vintage Hockey', 'Vieilles cartes NHL', 5),
       ('Full Mix', 'Collection complète multi-sets', 6);


-- 6. Possessions (liées aux collections et utilisateurs)
INSERT INTO possession (quantite, etat, prix_paye, date_acquisition, id_utilisateur, id_carte,
                        id_collection)
VALUES (1, 'Excellent', 120.00, '2024-03-01', 1, 1, 1),
       (3, 'Good', 5.00, '2024-03-02', 1, 2, 1),
       (2, 'Mint', 35.00, '2024-03-05', 4, 8, 4),
       (1, 'Mint', NULL, '2024-03-10', 2, 10, 2),
       (1, 'Excellent', NULL, '2024-03-12', 2, 11, 2),
       (4, 'Good', 1.00, '2024-04-01', 3, 5, 3),
       (1, 'Excellent', 90.00, '2024-03-25', 3, 13, 3),
       (1, 'Mint', NULL, '2024-04-03', 5, 12, 5),
       (2, 'Mint', 15.00, '2024-04-08', 6, 9, 6),
       (1, 'Good', NULL, '2024-04-08', 6, 15, 6),
       (1, 'Mint', 45.00, '2024-04-10', 2, 16, 2),
       (2, 'Excellent', 25.00, '2024-04-12', 5, 17, 5),
       (1, 'Good', NULL, '2024-04-13', 3, 18, 3),
       (1, 'Mint', 60.00, '2024-04-14', 6, 19, 6),
       (1, 'Excellent', 50.00, '2024-04-14', 1, 15, 1);


-- 7. Transactions (achat, vente, échange)
INSERT INTO transaction (type_transaction, date_transaction, montant, id_utilisateur, id_carte)
VALUES ('achat', '2024-03-01', 120.00, 1, 1),
       ('achat', '2024-03-02', 5.00, 1, 2),
       ('echange', '2024-03-10', NULL, 2, 10),
       ('vente', '2024-03-15', 90.00, 3, 13),
       ('echange', '2024-03-20', NULL, 3, 5),
       ('achat', '2024-03-22', 35.00, 4, 8),
       ('vente', '2024-04-01', 1.00, 3, 5),
       ('achat', '2024-04-03', 15.00, 6, 9),
       ('echange', '2024-04-04', NULL, 6, 15),
       ('achat', '2024-04-08', 0.00, 5, 12),
       ('achat', '2024-04-10', 45.00, 2, 16),
       ('echange', '2024-04-13', NULL, 3, 18),
       ('achat', '2024-04-14', 60.00, 6, 19),
       ('vente', '2024-04-15', 30.00, 5, 17),
       ('echange', '2024-04-15', NULL, 1, 15);
