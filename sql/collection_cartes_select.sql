set search_path to collection_cartes;

-- 1. Trouver les utilisateurs qui n'ont aucune collection.
SELECT u.prenom, u.nom
FROM utilisateur u
         LEFT JOIN collection c ON c.id_utilisateur = u.id
WHERE c.id IS NULL;

-- 2. Trouver les cartes qui ne sont associées à aucune possession.
SELECT cm.id, cm.nom
FROM carte_modele cm
WHERE NOT EXISTS (SELECT 1
                  FROM possession p
                  WHERE p.id_carte = cm.id);

-- 3. Lister toutes les possessions avec le nom de l'utilisateur et celui de la carte, la quantité
-- possédée et l'état de la carte.
SELECT u.prenom || ' ' || u.nom AS utilisateur,
       cm.nom                   AS carte,
       p.quantite,
       p.etat
FROM possession p
         JOIN utilisateur u ON u.id = p.id_utilisateur
         JOIN carte_modele cm ON cm.id = p.id_carte
ORDER BY utilisateur, carte;

-- 4. Trouver toutes les cartes Pokémon (set 1 et 2) avec leur rareté.
SELECT cm.nom AS carte,
       s.nom  AS set,
       r.nom  AS rarete
FROM carte_modele cm
         JOIN set_carte s ON s.id = cm.id_set
         LEFT JOIN rarete r ON r.id = cm.id_rarete
WHERE s.id IN (1, 2)
ORDER BY s.nom, cm.nom;

-- 5. Pour chaque utilisateur, afficher le total de cartes possédées.
SELECT u.prenom,
       u.nom,
       SUM(p.quantite) AS total_cartes
FROM utilisateur u
         LEFT JOIN possession p ON p.id_utilisateur = u.id
GROUP BY u.id, u.prenom, u.nom
ORDER BY total_cartes DESC NULLS LAST;

-- 6. Trouver les sets de cartes ayant plus de 3 modèles associés.
SELECT s.nom,
       COUNT(cm.id) AS nb_modeles
FROM set_carte s
         LEFT JOIN carte_modele cm ON cm.id_set = s.id
GROUP BY s.id, s.nom
HAVING COUNT(cm.id) > 3
ORDER BY nb_modeles DESC;

-- 7. Lister les transactions d'achat ou vente d'un montant supérieur à la moyenne des montants.
SELECT t.id,
       t.type_transaction,
       t.montant,
       u.prenom,
       u.nom
FROM transaction t
         JOIN utilisateur u ON u.id = t.id_utilisateur
WHERE t.montant > (SELECT AVG(montant)
                   FROM transaction
                   WHERE montant IS NOT NULL)
ORDER BY t.montant DESC;


--       REQUÊTES COMPLEXES (8 à 10)

-- 8. Pour chaque utilisateur, calculer la valeur totale de sa collection (somme prix_paye).
-- Exclure les utilisateurs sans possession.
SELECT u.prenom,
       u.nom,
       SUM(p.prix_paye) AS valeur_totale
FROM utilisateur u
         JOIN possession p ON p.id_utilisateur = u.id
GROUP BY u.id, u.prenom, u.nom
HAVING SUM(p.prix_paye) IS NOT NULL
ORDER BY valeur_totale DESC;

-- 9. Trouver la carte la plus possédée, en utilisant une fenêtre DENSE_RANK pour gérer les
-- égalités.
WITH compte AS (SELECT cm.id,
                       cm.nom,
                       COALESCE(SUM(p.quantite), 0) AS total
                FROM carte_modele cm
                         LEFT JOIN possession p ON p.id_carte = cm.id
                GROUP BY cm.id, cm.nom),
     ranked AS (SELECT c.*,
                       DENSE_RANK() OVER (ORDER BY c.total DESC) AS rang
                FROM compte c)
SELECT id, nom, total
FROM ranked
WHERE rang = 1;

-- 10. Statut des transactions : 'Gratuit' si montant NULL, 'Faible', 'Moyen' ou 'Élevé' selon la
-- valeur.
SELECT t.id,
       u.prenom || ' ' || u.nom AS utilisateur,
       cm.nom                   AS carte,
       CASE
           WHEN t.montant IS NULL THEN 'Gratuit'
           WHEN t.montant < 10 THEN 'Faible'
           WHEN t.montant < 50 THEN 'Moyen'
           ELSE 'Élevé'
           END                  AS categorie_transaction
FROM transaction t
         JOIN utilisateur u ON u.id = t.id_utilisateur
         JOIN carte_modele cm ON cm.id = t.id_carte
ORDER BY categorie_transaction, t.id;

