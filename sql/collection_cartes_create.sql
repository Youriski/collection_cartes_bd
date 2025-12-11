create schema collection_cartes;
set search_path to collection_cartes;

-- Représente les collectionneurs du système.
-- email est UNIQUE pour éviter les doublons.
CREATE TABLE utilisateur
(
    id               SERIAL PRIMARY KEY,
    nom              TEXT NOT NULL,
    prenom           TEXT NOT NULL,
    email            TEXT NOT NULL UNIQUE,
    date_inscription DATE NOT NULL DEFAULT CURRENT_DATE
);

-- Représente la rareté d'une carte (Pokémon, Magic the Gathering, etc.)
-- Certaines cartes n'ont PAS de rareté (cartes de sport)
-- donc les FK id_rarete dans carte_modele peuvent être NULL.
CREATE TABLE rarete
(
    id  SERIAL PRIMARY KEY,
    nom TEXT NOT NULL
);

-- Représente une série de cartes (Pokémon, Hockey, etc.)
CREATE TABLE set_carte
(
    id      SERIAL PRIMARY KEY,
    nom     TEXT    NOT NULL,
    annee   INTEGER NOT NULL,
    editeur TEXT    NOT NULL
);

-- Représente le modèle d’une carte.
-- id_set et id_rarete peuvent être NULL, certaines cartes
-- n'ont pas de rareté
-- Certains utilisateurs peuvent ajouter une carte sans définir
-- le set(pas de sets dans sports par exemple)
CREATE TABLE carte_modele
(
    id          SERIAL PRIMARY KEY,
    numero      INTEGER NOT NULL,
    nom         TEXT    NOT NULL,
    description TEXT,
    id_set      INTEGER REFERENCES set_carte (id) ON DELETE SET NULL,
    id_rarete   INTEGER REFERENCES rarete (id) ON DELETE SET NULL
);

-- Représente une collection qui appartient à un utilisateur.
-- ON DELETE CASCADE : si un utilisateur est supprimé,
-- toutes ses collections sont supprimées avec lui.
CREATE TABLE collection
(
    id             SERIAL PRIMARY KEY,
    nom            TEXT    NOT NULL,
    description    TEXT,
    id_utilisateur INTEGER NOT NULL REFERENCES utilisateur (id) ON DELETE CASCADE
);

-- Représente une carte que possède un utilisateur.
-- id_collection peut être NULL : une carte peut exister
-- sans être dans une collection.
-- id_utilisateur est NOT NULL : une possession appartient
-- toujours à un utilisateur.
-- id_carte est NOT NULL : référence un modèle existant.
CREATE TABLE possession
(
    id               SERIAL PRIMARY KEY,
    quantite         INTEGER NOT NULL CHECK (quantite >= 0),
    etat             TEXT,
    prix_paye        NUMERIC(8, 2),
    date_acquisition DATE,
    id_utilisateur   INTEGER NOT NULL REFERENCES utilisateur (id) ON DELETE CASCADE,
    id_carte         INTEGER NOT NULL REFERENCES carte_modele (id) ON DELETE CASCADE,
    id_collection    INTEGER REFERENCES collection (id) ON DELETE SET NULL
);

-- Représente l'historique des achats/ventes.
-- ON DELETE CASCADE : si l'utilisateur est supprimé, son
-- historique aussi.
-- type_transaction limité à {achat, vente, échange}.
-- Montant nullable pour suivre la logique échange = transaction la plus courante
CREATE TABLE transaction
(
    id               SERIAL PRIMARY KEY,
    type_transaction TEXT    NOT NULL
        CHECK (type_transaction IN ('achat', 'vente', 'echange'))
                                      DEFAULT 'echange',
    date_transaction DATE    NOT NULL DEFAULT CURRENT_DATE,
    montant          NUMERIC(8, 2),
    id_utilisateur   INTEGER NOT NULL REFERENCES utilisateur (id) ON DELETE CASCADE,
    id_carte         INTEGER NOT NULL REFERENCES carte_modele (id) ON DELETE CASCADE
);