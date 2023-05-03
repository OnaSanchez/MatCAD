-- Generado por Oracle SQL Developer Data Modeler 21.2.0.183.1957
--   en:        2021-12-12 12:52:43 CET
--   sitio:      Oracle Database 11g
--   tipo:      Oracle Database 11g



DROP TABLE acompanya CASCADE CONSTRAINTS;

DROP TABLE artista CASCADE CONSTRAINTS;

DROP TABLE coleccio CASCADE CONSTRAINTS;

DROP TABLE conte CASCADE CONSTRAINTS;

DROP TABLE dibuixa CASCADE CONSTRAINTS;

DROP TABLE distr_client CASCADE CONSTRAINTS;

DROP TABLE editorial CASCADE CONSTRAINTS;

DROP TABLE esta CASCADE CONSTRAINTS;

DROP TABLE factura CASCADE CONSTRAINTS;

DROP TABLE figures CASCADE CONSTRAINTS;

DROP TABLE guionitza CASCADE CONSTRAINTS;

DROP TABLE llista CASCADE CONSTRAINTS;

DROP TABLE nom_artista CASCADE CONSTRAINTS;

DROP TABLE personatge CASCADE CONSTRAINTS;

DROP TABLE premi CASCADE CONSTRAINTS;

DROP TABLE producte CASCADE CONSTRAINTS;

DROP TABLE rev_publi CASCADE CONSTRAINTS;

DROP TABLE salo CASCADE CONSTRAINTS;

DROP TABLE subministra CASCADE CONSTRAINTS;

DROP TABLE ticket CASCADE CONSTRAINTS;

DROP TABLE ubicacio CASCADE CONSTRAINTS;

-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE acompanya (
    personatge_nom  CHAR(100 CHAR) NOT NULL,
    personatge_nom1 CHAR(100 CHAR) NOT NULL
);

ALTER TABLE acompanya ADD CONSTRAINT acompanya_pk PRIMARY KEY ( personatge_nom,
                                                                personatge_nom1 );

CREATE TABLE artista (
    any_naixement DATE,
    nacionalitat  CHAR(100 CHAR),
    nom           CHAR(100 CHAR) NOT NULL,
    cognom        CHAR(100 CHAR) NOT NULL
);

ALTER TABLE artista ADD CONSTRAINT artista_pk PRIMARY KEY ( cognom,
                                                            nom );

CREATE TABLE coleccio (
    tipus         CHAR(100 CHAR),
    ambient       CHAR(100 CHAR),
    p_principal   CHAR(100 CHAR),
    genere        CHAR(100 CHAR),
    nom           CHAR(100 CHAR) NOT NULL,
    tancada       CHAR(1),
    volumns       INTEGER,
    num_exemplars INTEGER,
    any_final     DATE,
    idioma        CHAR(100 CHAR),
    any_inicial   DATE
);

ALTER TABLE coleccio ADD CONSTRAINT coleccio_pk PRIMARY KEY ( nom );

CREATE TABLE conte (
    producte_codi INTEGER NOT NULL,
    ticket_codi   INTEGER NOT NULL,
    quan_exempl   INTEGER,
    preu_unitat   NUMBER
);

ALTER TABLE conte ADD CONSTRAINT conte_pk PRIMARY KEY ( producte_codi,
                                                        ticket_codi );

CREATE TABLE dibuixa (
    artista_cognom          CHAR(100 CHAR) NOT NULL,
    artista_nom             CHAR(100 CHAR) NOT NULL,
    rev_publi_producte_codi INTEGER NOT NULL
);

ALTER TABLE dibuixa
    ADD CONSTRAINT dibuixa_pkv2 PRIMARY KEY ( artista_cognom,
                                              artista_nom,
                                              rev_publi_producte_codi );

CREATE TABLE distr_client (
    preferencies CHAR(1000 CHAR),
    es_client    CHAR(1),
    contacte     CLOB,
    nif          INTEGER NOT NULL,
    c_postal     INTEGER,
    nom          CHAR(100 CHAR),
    adreça       CHAR(100 CHAR)
);

ALTER TABLE distr_client ADD CONSTRAINT distr_client_pk PRIMARY KEY ( nif );

CREATE TABLE editorial (
    responsable CHAR(100 CHAR),
    nom         CHAR(100 CHAR) NOT NULL,
    adreça      CHAR(100 CHAR)
);

ALTER TABLE editorial ADD CONSTRAINT editorial_pk PRIMARY KEY ( nom );

CREATE TABLE esta (
    personatge_nom          CHAR(100 CHAR) NOT NULL,
    rev_publi_producte_codi INTEGER NOT NULL
);

ALTER TABLE esta ADD CONSTRAINT esta_pk PRIMARY KEY ( personatge_nom,
                                                      rev_publi_producte_codi );

CREATE TABLE factura (
    data             DATE,
    preu             NUMBER,
    venta            CHAR(1),
    codi             INTEGER NOT NULL,
    iva              NUMBER,
    distr_client_nif INTEGER NOT NULL
);

ALTER TABLE factura ADD CONSTRAINT factura_pk PRIMARY KEY ( codi );

CREATE TABLE figures (
    tamany        NUMBER,
    pes           NUMBER,
    nom           CHAR(100 CHAR),
    "any"         DATE,
    producte_codi INTEGER NOT NULL
);

CREATE TABLE guionitza (
    artista_cognom          CHAR(100 CHAR) NOT NULL,
    artista_nom             CHAR(100 CHAR) NOT NULL,
    rev_publi_producte_codi INTEGER NOT NULL
);

ALTER TABLE guionitza
    ADD CONSTRAINT guionitza_pkv1 PRIMARY KEY ( artista_cognom,
                                                artista_nom,
                                                rev_publi_producte_codi );

CREATE TABLE llista (
    producte_codi INTEGER NOT NULL,
    factura_codi  INTEGER NOT NULL,
    preu_unitat   NUMBER,
    quant_exempl  INTEGER
);

ALTER TABLE llista ADD CONSTRAINT llista_pk PRIMARY KEY ( producte_codi,
                                                          factura_codi );

CREATE TABLE nom_artista (
    nom_artista    CHAR(100 CHAR),
    artista_cognom CHAR(100 CHAR) NOT NULL,
    artista_nom    CHAR(100 CHAR) NOT NULL
);

CREATE TABLE personatge (
    dibuixant  CHAR(100 CHAR),
    caracter   CHAR(100 CHAR),
    nom        CHAR(100 CHAR) NOT NULL,
    fisionomia CHAR(100 CHAR),
    ambient    CHAR(100 CHAR),
    genere     CHAR(100 CHAR),
    creador    CHAR(100 CHAR),
    tipus      CHAR(100 CHAR)
);

ALTER TABLE personatge ADD CONSTRAINT personatge_pk PRIMARY KEY ( nom );

CREATE TABLE premi (
    nom                     CHAR(100 CHAR),
    edicio                  INTEGER NOT NULL,
    especialitzacio         CHAR(100 CHAR) NOT NULL,
    salo_nom                CHAR(100 CHAR) NOT NULL,
    artista_cognom          CHAR(100 CHAR) NOT NULL,
    artista_nom             CHAR(100 CHAR) NOT NULL,
    "any"                   DATE,
    rev_publi_producte_codi INTEGER NOT NULL
);

ALTER TABLE premi
    ADD CONSTRAINT premi_pk PRIMARY KEY ( edicio,
                                          especialitzacio,
                                          salo_nom );

CREATE TABLE producte (
    codi  INTEGER NOT NULL,
    stock INTEGER
);

ALTER TABLE producte ADD CONSTRAINT producte_pk PRIMARY KEY ( codi );

CREATE TABLE rev_publi (
    genere        CHAR(100 CHAR),
    autor         CHAR(100 CHAR),
    isbn          INTEGER,
    titol         CHAR(100 CHAR),
    edicio        INTEGER,
    idioma        CHAR(100 CHAR),
    tipus         CHAR(100 CHAR),
    producte_codi INTEGER NOT NULL,
    editorial_nom CHAR(100 CHAR) NOT NULL,
    coleccio_nom  CHAR(100 CHAR) NOT NULL
);

ALTER TABLE rev_publi ADD CONSTRAINT rev_publi_pk PRIMARY KEY ( producte_codi );

CREATE TABLE salo (
    nom    CHAR(100 CHAR) NOT NULL,
    mes    CHAR(100 CHAR),
    ciutat CHAR(100 CHAR)
);

ALTER TABLE salo ADD CONSTRAINT salo_pk PRIMARY KEY ( nom );

CREATE TABLE subministra (
    producte_codi    INTEGER NOT NULL,
    distr_client_nif INTEGER NOT NULL
);

ALTER TABLE subministra ADD CONSTRAINT subministra_pk PRIMARY KEY ( producte_codi,
                                                                    distr_client_nif );

CREATE TABLE ticket (
    codi        INTEGER NOT NULL,
    preu        NUMBER,
    iva         NUMBER,
    data        DATE,
    num_targeta INTEGER
);

ALTER TABLE ticket ADD CONSTRAINT ticket_pk PRIMARY KEY ( codi );

CREATE TABLE ubicacio (
    num_unitats   INTEGER,
    fila          INTEGER NOT NULL,
    sala          INTEGER NOT NULL,
    estant        INTEGER NOT NULL,
    columna       INTEGER NOT NULL,
    producte_codi INTEGER NOT NULL
);

ALTER TABLE ubicacio
    ADD CONSTRAINT ubicacio_pk PRIMARY KEY ( fila,
                                             sala,
                                             estant,
                                             columna );

ALTER TABLE acompanya
    ADD CONSTRAINT acompanya_personatge_fk FOREIGN KEY ( personatge_nom )
        REFERENCES personatge ( nom )
            ON DELETE CASCADE;

ALTER TABLE acompanya
    ADD CONSTRAINT acompanya_personatge_fkv1 FOREIGN KEY ( personatge_nom1 )
        REFERENCES personatge ( nom )
            ON DELETE CASCADE;

ALTER TABLE conte
    ADD CONSTRAINT conte_producte_fk FOREIGN KEY ( producte_codi )
        REFERENCES producte ( codi );

ALTER TABLE conte
    ADD CONSTRAINT conte_ticket_fk FOREIGN KEY ( ticket_codi )
        REFERENCES ticket ( codi );

ALTER TABLE dibuixa
    ADD CONSTRAINT dibuixa_artista_fk FOREIGN KEY ( artista_cognom,
                                                    artista_nom )
        REFERENCES artista ( cognom,
                             nom )
                              ON DELETE CASCADE;

ALTER TABLE dibuixa
    ADD CONSTRAINT dibuixa_rev_publi_fk FOREIGN KEY ( rev_publi_producte_codi )
        REFERENCES rev_publi ( producte_codi )
         ON DELETE CASCADE;

ALTER TABLE esta
    ADD CONSTRAINT esta_personatge_fk FOREIGN KEY ( personatge_nom )
        REFERENCES personatge ( nom )
         ON DELETE CASCADE;

ALTER TABLE esta
    ADD CONSTRAINT esta_rev_publi_fk FOREIGN KEY ( rev_publi_producte_codi )
        REFERENCES rev_publi ( producte_codi )
         ON DELETE CASCADE;

ALTER TABLE factura
    ADD CONSTRAINT factura_distr_client_fk FOREIGN KEY ( distr_client_nif )
        REFERENCES distr_client ( nif );

ALTER TABLE figures
    ADD CONSTRAINT figures_producte_fk FOREIGN KEY ( producte_codi )
        REFERENCES producte ( codi )
         ON DELETE CASCADE;

ALTER TABLE guionitza
    ADD CONSTRAINT guionitza_artista_fk FOREIGN KEY ( artista_cognom,
                                                      artista_nom )
        REFERENCES artista ( cognom,
                             nom )
                              ON DELETE CASCADE;

ALTER TABLE guionitza
    ADD CONSTRAINT guionitza_rev_publi_fk FOREIGN KEY ( rev_publi_producte_codi )
        REFERENCES rev_publi ( producte_codi )
         ON DELETE CASCADE;

ALTER TABLE llista
    ADD CONSTRAINT llista_factura_fk FOREIGN KEY ( factura_codi )
        REFERENCES factura ( codi );

ALTER TABLE llista
    ADD CONSTRAINT llista_producte_fk FOREIGN KEY ( producte_codi )
        REFERENCES producte ( codi );

ALTER TABLE nom_artista
    ADD CONSTRAINT nom_artista_artista_fk FOREIGN KEY ( artista_cognom,
                                                        artista_nom )
        REFERENCES artista ( cognom,
                             nom )
                              ON DELETE CASCADE;

ALTER TABLE premi
    ADD CONSTRAINT premi_artista_fk FOREIGN KEY ( artista_cognom,
                                                  artista_nom )
        REFERENCES artista ( cognom,
                             nom )
                              ON DELETE CASCADE;

ALTER TABLE premi
    ADD CONSTRAINT premi_rev_publi_fk FOREIGN KEY ( rev_publi_producte_codi )
        REFERENCES rev_publi ( producte_codi )
         ON DELETE CASCADE;

ALTER TABLE premi
    ADD CONSTRAINT premi_salo_fk FOREIGN KEY ( salo_nom )
        REFERENCES salo ( nom )
         ON DELETE CASCADE;

ALTER TABLE rev_publi
    ADD CONSTRAINT rev_publi_coleccio_fk FOREIGN KEY ( coleccio_nom )
        REFERENCES coleccio ( nom )
         ON DELETE CASCADE;

ALTER TABLE rev_publi
    ADD CONSTRAINT rev_publi_editorial_fk FOREIGN KEY ( editorial_nom )
        REFERENCES editorial ( nom )
         ON DELETE CASCADE;

ALTER TABLE rev_publi
    ADD CONSTRAINT rev_publi_producte_fk FOREIGN KEY ( producte_codi )
        REFERENCES producte ( codi )
         ON DELETE CASCADE;

ALTER TABLE subministra
    ADD CONSTRAINT subministra_distr_client_fk FOREIGN KEY ( distr_client_nif )
        REFERENCES distr_client ( nif )
         ON DELETE CASCADE;

ALTER TABLE subministra
    ADD CONSTRAINT subministra_producte_fk FOREIGN KEY ( producte_codi )
        REFERENCES producte ( codi )
         ON DELETE CASCADE;

ALTER TABLE ubicacio
    ADD CONSTRAINT ubicacio_producte_fk FOREIGN KEY ( producte_codi )
        REFERENCES producte ( codi );



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            21
-- CREATE INDEX                             0
-- ALTER TABLE                             43
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0

INSERT INTO EDITORIAL VALUES ('Jordi Cruz', 'Pepe', 'Plaça Vaixell Maria Assumpta');
INSERT INTO COLECCIO VALUES('Novela', 'Edad Media', 'Maria Rosa', 'Romance', 'Las desdichas de Maria Rosa', 1, 3, 4, TO_DATE('11/03/1998', 'DD/MM/YYYY'), 'Español',TO_DATE('17/07/1993', 'DD/MM/YYYY'));
INSERT INTO PRODUCTE VALUES('0001', '0');
INSERT INTO REV_PUBLI VALUES('Romance', 'JK Rowling', '0153812', 'Maria Rosa se embaraza', 5, 'Español', 'Novela', '0001', 'Pepe', 'Las desdichas de Maria Rosa');
INSERT INTO ARTISTA VALUES(TO_DATE('11/03/1984', 'DD/MM/YYYY'), 'Británica', 'Emma', 'Watson');
INSERT INTO NOM_ARTISTA VALUES('Fangoria', 'Watson', 'Emma');
INSERT INTO GUIONITZA VALUES('Watson', 'Emma', '0001');
INSERT INTO DIBUIXA VALUES('Watson', 'Emma', '0001');
INSERT INTO SALO VALUES('El Salon de la Virgen de Guadalupe', 'Enero', 'Barcelona');
INSERT INTO PREMI VALUES('Drama de la década', 5, 'Mejor guion', 'El Salon de la Virgen de Guadalupe', 'Watson', 'Emma', TO_DATE('02/01/2021', 'DD/MM/YYYY'), '0001');
INSERT INTO UBICACIO VALUES(0, 3, 4, 7, 5, '0001');
INSERT INTO DISTR_CLIENT VALUES ('Novel·les romàntiques', 1, 633707478, 53868858, 08172, 'Pedro Rubiales', 'c/Santa Rosa 26 baixos 3a');
INSERT INTO DISTR_CLIENT VALUES ('Portal de belen', 0, 673998180, 77126633, 08105, 'Jorje Jabier Basques', 'c/false 123 bajos p2');
INSERT INTO FACTURA VALUES (TO_DATE('16/04/2012', 'DD/MM/YYYY'),14.35, 1, 1541785, 21, 53868858);
INSERT INTO FACTURA VALUES (TO_DATE('28/04/2012', 'DD/MM/YYYY'), 5000, 0, 152535, 21, 77126633);
INSERT INTO LLISTA VALUES('0001',1541785, 13.50, 1);
INSERT INTO TICKET VALUES(3672, 22, 14, TO_DATE('01/01/2001', 'DD/MM/YYYY'), NULL);
INSERT INTO CONTE VALUES('0001', 3672, 5, 10.50);
INSERT INTO PERSONATGE VALUES('Emma Watson', 'Desobediente', 'Harry Potter', 'Prim', 'Hogwarts', 'Fantasia', 'JK Rowling', 'Noi');
INSERT INTO PERSONATGE VALUES ('Emma Watson', 'Picaro', 'Lazaro de Tormes', 'Noi', 'Espanya a l’any 1554', 'Novel·la Picaresca', 'Anonimous', 'Principal');
INSERT INTO ACOMPANYA VALUES ('Harry Potter', 'Lazaro de Tormes');
INSERT INTO ESTA VALUES('Harry Potter', '0001');


INSERT INTO EDITORIAL VALUES ('Penelope Cruz', 'Carmen de Mairena', 'Carrer del Doctor Trueta, 1o, 2a');
INSERT INTO COLECCIO VALUES('Comic', 'Prehistoria', 'El agua deshidrata', 'Accion', 'Aventuras entre dinosaurios', 0, 9, 7, TO_DATE('11/03/2025', 'DD/MM/YYYY'), 'Catalan',TO_DATE('17/07/2007', 'DD/MM/YYYY'));
INSERT INTO PRODUCTE VALUES('0002', '7');
INSERT INTO REV_PUBLI VALUES('Accion', 'Soraka', '097836', 'Pedro pica piedra', 5, 'Catalan', 'Comic', '0002', 'Carmen de Mairena', 'Aventuras entre dinosaurios');
INSERT INTO ARTISTA VALUES(TO_DATE('11/03/1958', 'DD/MM/YYYY'), 'Polaco', 'Bond', 'James Bond');
INSERT INTO NOM_ARTISTA VALUES('007', 'James Bond', 'Bond');
INSERT INTO GUIONITZA VALUES('James Bond', 'Bond', '0002');
INSERT INTO DIBUIXA VALUES('James Bond', 'Bond', '0002');
INSERT INTO SALO VALUES('Comicon', 'Febrero', 'Barcelona');
INSERT INTO PREMI VALUES('Premios de consolacion', 3, 'Mejor comedia', 'Comicon', 'James Bond', 'Bond', TO_DATE('11/02/2021', 'DD/MM/YYYY'), '0002');
INSERT INTO UBICACIO VALUES(7, 3, 5, 6, 9, '0002');
INSERT INTO DISTR_CLIENT VALUES ('Comicon', 1, 673180809, 53598658, 08913, 'Ibai Llanos', 'c/Carlos Moreno ático 1a');
INSERT INTO DISTR_CLIENT VALUES ('USSR', 0, 672348180, 77987633, 08105, 'Piqué', 'c/Misco Indiana Jones bajos p2');
INSERT INTO FACTURA VALUES (TO_DATE('16/07/2021', 'DD/MM/YYYY'),116.35, 1, 1793785, 18, 53598658);
INSERT INTO FACTURA VALUES (TO_DATE('28/07/2021', 'DD/MM/YYYY'), 3586.90, 0, 168535, 18, 77987633);
INSERT INTO LLISTA VALUES('0002',1793785, 16.95, 3);
INSERT INTO TICKET VALUES(4798, 34.95, 14, TO_DATE('05/11/2021', 'DD/MM/YYYY'), NULL);
INSERT INTO CONTE VALUES('0002', 4798, 5, 13.90);
INSERT INTO PERSONATGE VALUES('Bond James Bond', 'Curioso', 'Percy Jackson', 'Humano', 'Tierra', 'Fantasia', 'Rick Riordan', 'Principal');
INSERT INTO PERSONATGE VALUES ('Bond James Bond', 'Aventurera', 'Barbie', 'Noia', 'Fairytopia', 'Infantil', 'Marina Yers', 'Secundario');
INSERT INTO ACOMPANYA VALUES ('Percy Jackson', 'Barbie');
INSERT INTO ESTA VALUES('Barbie', '0002');


INSERT INTO EDITORIAL VALUES ('Tom Cruz', 'Planeta', 'Wiezniow oswiecimia 20');
INSERT INTO COLECCIO VALUES('Manga', 'Japon', 'Albert', 'Terror', 'Algoritmia y combinatoria de grafos. Métodos heurísticos', 0, 9, 7, TO_DATE('15/06/2020', 'DD/MM/YYYY'), 'Japonés',TO_DATE('23/02/2020', 'DD/MM/YYYY'));
INSERT INTO PRODUCTE VALUES('0003', '5');
INSERT INTO PRODUCTE VALUES('40', '5');
INSERT INTO REV_PUBLI VALUES('Terror', 'Lluís', '098375', 'Inicialización: Dijkstra', 5, 'Japonés', 'Manga', '40', 'Planeta', 'Algoritmia y combinatoria de grafos. Métodos heurísticos');
INSERT INTO REV_PUBLI VALUES('Terror', 'Lluís', '098375', 'Continuación: Greedy', 5, 'Japonés', 'Manga', '0003', 'Planeta', 'Algoritmia y combinatoria de grafos. Métodos heurísticos');
INSERT INTO ARTISTA VALUES(TO_DATE('21/08/1976', 'DD/MM/YYYY'), 'Turco', 'Lluís', 'Alseda');
INSERT INTO NOM_ARTISTA VALUES('C', 'Alseda', 'Lluís');
INSERT INTO GUIONITZA VALUES('Alseda', 'Lluís', '0003');
INSERT INTO GUIONITZA VALUES('Alseda', 'Lluís', '40');
INSERT INTO DIBUIXA VALUES('Alseda', 'Lluís', '0003');
INSERT INTO SALO VALUES('Terror NY', 'Marzo', 'Nueva York');
INSERT INTO PREMI VALUES('Terror', 3, 'Mejor thriller para universitarios', 'Terror NY', 'Alseda', 'Lluís', TO_DATE('09/10/2019', 'DD/MM/YYYY'), '0003');
INSERT INTO UBICACIO VALUES(4, 2, 9, 1, 3, '0003');
INSERT INTO DISTR_CLIENT VALUES ('Soltero y matemático', 1, 3141592, 42598658, 7300811, 'Begoña Luces', 'Nakajimacho Naka Ward 21');
INSERT INTO DISTR_CLIENT VALUES ('Matemática e informática', 0, 672589280, 76987633, 08105, 'Soledad García', 'Calle Wallaby, 42, Sydney');
INSERT INTO FACTURA VALUES (TO_DATE('16/11/2021', 'DD/MM/YYYY'),224.35, 1, 1683785, 17, 42598658);
INSERT INTO FACTURA VALUES (TO_DATE('28/11/2021', 'DD/MM/YYYY'), 3586.90, 0, 138535, 17, 76987633);
INSERT INTO LLISTA VALUES('0003',1683785, 28.95, 2);
INSERT INTO TICKET VALUES(5389, 42.95, 8, TO_DATE('05/11/2021', 'DD/MM/YYYY'), NULL);
INSERT INTO CONTE VALUES('0003', 5389, 3, 28.90);
INSERT INTO PERSONATGE VALUES('Alseda Lluís', 'Inteligente / Amable', 'Albert', 'Dios', 'UAB', 'Novela Realista', 'UAB', 'Principal');
INSERT INTO PERSONATGE VALUES ('Alseda Lluís', 'Surfero', 'Marc', 'Humano', 'UAB', 'Novela Realista', 'UAB', 'Villano');
INSERT INTO ACOMPANYA VALUES ('Albert', 'Marc');
INSERT INTO ESTA VALUES('Albert', '0003');


INSERT INTO EDITORIAL VALUES ('Mahoma', 'Grandes Lagos', 'Plaza du Casino 9800');
INSERT INTO COLECCIO VALUES('Historia corta', 'Futurista', 'Marinette', 'Cientia ficción', 'Las aventuras de LadyBug y CatNoir', 0, 3, 3, TO_DATE('11/03/2020', 'DD/MM/YYYY'), 'Francés',TO_DATE('27/08/2018', 'DD/MM/YYYY'));
INSERT INTO PRODUCTE VALUES('0004', '3');
INSERT INTO REV_PUBLI VALUES('Ciencia ficción', 'Katarina', '091416', 'LadyBug descubre París', 1, 'Francés', 'Historia corta', '0004', 'Grandes Lagos', 'Las aventuras de LadyBug y CatNoir');
INSERT INTO ARTISTA VALUES(TO_DATE('05/10/1049', 'DD/MM/YYYY'), 'Francés', 'Karl', 'Marx');
INSERT INTO NOM_ARTISTA VALUES('MK histories', 'Marx', 'Karl');
INSERT INTO GUIONITZA VALUES('Marx', 'Karl', '0004');
INSERT INTO DIBUIXA VALUES('Marx', 'Karl', '0004');
INSERT INTO PREMI VALUES('Historia corta', 5, 'Mejor colección infantil', 'El Salon de la Virgen de Guadalupe', 'Marx', 'Karl', TO_DATE('07/01/2021', 'DD/MM/YYYY'), '0004');
INSERT INTO UBICACIO VALUES(2, 3, 6, 9, 9, '0004');
INSERT INTO DISTR_CLIENT VALUES ('Historias infantiles', 1, 570980809, 59598658, 08923, 'Mario López', 'Scaborough 22');
INSERT INTO DISTR_CLIENT VALUES ('Historias infantiles y relatos cortos', 0, 672748180, 73987633, 08125, 'Adam Smith', 'Flokagata 02');
INSERT INTO FACTURA VALUES (TO_DATE('15/10/2021', 'DD/MM/YYYY'),34.08, 1, 2793785, 21, 59598658);
INSERT INTO FACTURA VALUES (TO_DATE('26/10/2021', 'DD/MM/YYYY'), 124.90, 0, 268535, 21, 73987633);
INSERT INTO LLISTA VALUES('0004',2793785, 16.95, 3);
INSERT INTO TICKET VALUES(6579, 115.95, 21, TO_DATE('04/03/2021', 'DD/MM/YYYY'), 567832415678);
INSERT INTO CONTE VALUES('0004', 6579, 6, 12.95);
INSERT INTO PERSONATGE VALUES('Karl Marx', 'Intrépida', 'Marinette', 'Humano', 'París', 'Ciencia Ficción', 'Oliver Cromwell', 'Principal');
INSERT INTO PERSONATGE VALUES ('Karl Marx', 'Coqueto', 'Adrián','Humano', 'París', 'Ciencia Ficción', 'Oliver Cromwell', 'Secundario');
INSERT INTO ACOMPANYA VALUES ('Marinette', 'Adrián');
INSERT INTO ESTA VALUES('Marinette', '0004');


INSERT INTO EDITORIAL VALUES ('Beethoven', 'Valdemar', 'Loneless lake 14');
INSERT INTO COLECCIO VALUES('Novela', 'Futurista', 'Garen', 'Romántica', 'El caballero de las estrellas', 1, 5, 8, TO_DATE('09/12/2019', 'DD/MM/YYYY'), 'Español',TO_DATE('13/08/2013', 'DD/MM/YYYY'));
INSERT INTO PRODUCTE VALUES('0005', '8');
INSERT INTO REV_PUBLI VALUES('Romance', 'Miguel Ángel', '091418', 'Hasta el infinito y más allá', 1, 'Español', 'Romance', '0005', 'Valdemar', 'El caballero de las estrellas');
INSERT INTO ARTISTA VALUES(TO_DATE('01/07/1997', 'DD/MM/YYYY'), 'Italiano', 'Michael', 'Sclafani');
INSERT INTO NOM_ARTISTA VALUES('SM', 'Sclafani', 'Michael');
INSERT INTO GUIONITZA VALUES('Sclafani', 'Michael', '0005');
INSERT INTO DIBUIXA VALUES('Sclafani', 'Michael', '0005');
INSERT INTO SALO VALUES('Romicfi', 'Enero', 'Barcelona');
INSERT INTO UBICACIO VALUES(2, 3, 6, 4, 9, '0005');
INSERT INTO DISTR_CLIENT VALUES ('Romance, ficción y futurismo', 1, 570464609, 59958658, 14157, 'René Descartes', 'Downton Abbey 6');
INSERT INTO DISTR_CLIENT VALUES ('Romance', 0, 672478180, 739867833, 03145, 'Monica Gueller', 'Carrer Gruliasco 64');
INSERT INTO FACTURA VALUES (TO_DATE('15/03/2021', 'DD/MM/YYYY'),115.08, 1, 4393785, 21, 59958658);
INSERT INTO FACTURA VALUES (TO_DATE('26/03/2021', 'DD/MM/YYYY'), 134.90, 0, 168533, 21, 739867833);
INSERT INTO LLISTA VALUES('0005',4393785, 32.95, 3);
INSERT INTO TICKET VALUES(3334, 65.95, 21, TO_DATE('04/03/2021', 'DD/MM/YYYY'), 467832415678);
INSERT INTO CONTE VALUES('0005', 3334, 6, 11.95);
INSERT INTO PERSONATGE VALUES('Sclafani Michael', 'Reflexivo', 'Platón', 'Humano', 'Antigua Grecia', 'Filosofia', 'Omar', 'Villano');
INSERT INTO PERSONATGE VALUES ('Sclafani Michael', 'Reflexivo', 'Sócrates','Humano', 'Antigua Grecia', 'Filosofia', 'Agustín de Hipona', 'Héroe');
INSERT INTO ACOMPANYA VALUES ('Sócrates', 'Platón');
INSERT INTO ESTA VALUES('Sócrates', '0005');


INSERT INTO EDITORIAL VALUES ('Jesus Cruz', 'Kaiser II', 'Downtown 73');
INSERT INTO COLECCIO VALUES('Novela', 'Grecia', 'Hilbert', 'Policiaca', '????', 0, 2, 12, TO_DATE('21/06/2019', 'DD/MM/YYYY'), 'Ruso',TO_DATE('20/04/2016', 'DD/MM/YYYY'));
INSERT INTO PRODUCTE VALUES('1003', '12');
INSERT INTO REV_PUBLI VALUES('policiaca', 'Gran Hotel Las Vegas', '156874', 'Napoleon 2 el retorno', 5, 'Rus', 'Novela', '1003', 'Kaiser II', '????');
INSERT INTO ARTISTA VALUES(TO_DATE('12/08/1999', 'DD/MM/YYYY'), 'Ucraniano', 'Wiston', 'Churchill');
INSERT INTO NOM_ARTISTA VALUES('C', 'Churchill', 'Wiston');
INSERT INTO GUIONITZA VALUES('Churchill', 'Wiston', '1003');
INSERT INTO DIBUIXA VALUES('Churchill', 'Wiston', '1003');
INSERT INTO SALO VALUES('WWII', 'Enero', 'Normandie');
INSERT INTO PREMI VALUES('Policiaca', 3, 'Mejor novela rara del 99', 'Terror NY', 'Churchill', 'Wiston', TO_DATE('12/12/1999', 'DD/MM/YYYY'), '1003');
INSERT INTO UBICACIO VALUES(43, 23,9, 1,333, '1003');
INSERT INTO DISTR_CLIENT VALUES ('Soldado Aleman ', 1, 3141592, 56587598, 75464, 'Begoña Luces', 'Monte Olympo 44');
INSERT INTO DISTR_CLIENT VALUES ('Matemática e informática', 0, 672589280, 94325156, 43631, 'De Gaulle', 'Valle de Soledad 35');
INSERT INTO FACTURA VALUES (TO_DATE('22/04/2002', 'DD/MM/YYYY'),428.3, 1, 555555555555, 17, 56587598);
INSERT INTO FACTURA VALUES (TO_DATE('28/04/2012', 'DD/MM/YYYY'), 3586.90, 0, 338535, 17, 94325156);
INSERT INTO LLISTA VALUES('1003',555555555555, 28.95, 30);
INSERT INTO TICKET VALUES(444444444, 42.95, 8, TO_DATE('05/11/2021', 'DD/MM/YYYY'), 777666888);
INSERT INTO CONTE VALUES('1003', 444444444, 3, 28.90);
INSERT INTO PERSONATGE VALUES('Wiston hurchill', 'Grande', 'Rudolf', 'Animal', 'Alemania 1933', 'Novela Policiaca', 'Alemania 1933', 'Principal');
INSERT INTO PERSONATGE VALUES ('Wiston hurchill', 'Loquillo', 'Peter', 'Humano', 'Englaterra 1933', 'Novela Policiaca', 'Paris 1933', 'Domador de caballos');
INSERT INTO ACOMPANYA VALUES ('Rudolf', 'Peter');
INSERT INTO ESTA VALUES('Peter', '1003');


INSERT INTO EDITORIAL VALUES ('Eduardo manos Cruz', 'Michael Moore', 'Ya no se que nombre poner 73');
INSERT INTO COLECCIO VALUES('Comic', 'Antigua Roma', 'Cristiano Ronaldo', 'Suspense', 'Un mono facheiro afeitando mio pelo de la barba', 0, 4, 2, TO_DATE('31/01/2020', 'DD/MM/YYYY'), 'Portugues',TO_DATE('22/04/2010', 'DD/MM/YYYY'));
INSERT INTO PRODUCTE VALUES('0007', '2');
INSERT INTO REV_PUBLI VALUES('suspense', 'Papel Johnson', '6526346', 'Amigo de Rivera', 5, 'Portugues', 'Comic', '0007', 'Michael Moore', 'Un mono facheiro afeitando mio pelo de la barba');
INSERT INTO ARTISTA VALUES(TO_DATE('22/04/1999', 'DD/MM/YYYY'), 'Brasileño', 'Eustaquio', 'Abichuelas');
INSERT INTO NOM_ARTISTA VALUES('Ese tio de ahí', 'Abichuelas', 'Eustaquio');
INSERT INTO GUIONITZA VALUES('Abichuelas', 'Eustaquio', '0007');
INSERT INTO DIBUIXA VALUES('Abichuelas', 'Eustaquio', '0007');
INSERT INTO SALO VALUES('Agallas un perro cobarde', 'Abril', 'Alabama');
INSERT INTO PREMI VALUES('Suspense', 4, 'Gracias a esto no puedo dormir', 'Agallas un perro cobarde', 'Abichuelas', 'Eustaquio', TO_DATE('10/04/2018', 'DD/MM/YYYY'), '0007');
INSERT INTO UBICACIO VALUES(4, 2,9, 1,333, '0007');
INSERT INTO DISTR_CLIENT VALUES ('Soldadito Marinero ', 1, 3141592, 34563753754, 75464, 'Fito i Fitipaldis', 'En algun lugar de la mancha cuyo nombre no quiero acordarme');
INSERT INTO DISTR_CLIENT VALUES ('Matemática e informática', 0, 672589280, 66666099099, 43631, 'Ariana Grande', 'Valle de Soledad estando sola solamente solemne');
INSERT INTO FACTURA VALUES (TO_DATE('22/04/2019', 'DD/MM/YYYY'),428.3, 1, 55768148245, 17, 34563753754);
INSERT INTO FACTURA VALUES (TO_DATE('28/04/2019', 'DD/MM/YYYY'), 3586.90, 0, 3535, 17, 66666099099);
INSERT INTO LLISTA VALUES('0007',55768148245, 28.95, 30);
INSERT INTO TICKET VALUES(345675436786578909, 42.95, 8, TO_DATE('05/11/2021', 'DD/MM/YYYY'), 77766474698246888);
INSERT INTO CONTE VALUES('0007', 345675436786578909, 3, 28.90);
INSERT INTO PERSONATGE VALUES('Eustaquio Abichuelas', 'Sabio', 'Agallas', 'Animal', 'Sweet home Alabama', 'Comic', 'Dios', 'Principal');
INSERT INTO PERSONATGE VALUES ('Eustaquio Abichuelas', 'Abuelo', 'Kualalumpur', 'Ciudad', 'Englaterra 1933', 'Comic', 'Dios', 'Ente omnipresente');
INSERT INTO ACOMPANYA VALUES ('Agallas', 'Kualalumpur');
INSERT INTO ESTA VALUES('Agallas', '0007');


INSERT INTO EDITORIAL VALUES ('Juan Cruz', 'Círculo Rojo', 'Rambla de Sant Joan, 79');
INSERT INTO COLECCIO VALUES('Comic', 'Vaqueros', 'Rachel Green', 'Romántica', 'Sabes que estoy colgando en tus manos', 0, 1, 2, TO_DATE('08/08/2017', 'DD/MM/YYYY'), 'Inglés',TO_DATE('13/08/2015', 'DD/MM/YYYY'));
INSERT INTO PRODUCTE VALUES('12', '8');
INSERT INTO REV_PUBLI VALUES('Romance', 'La Oreja de Van Gogh', 091234, 'Asi que no me dejes caer', 2, 'Español', 'Romance', '12', 'Círculo Rojo', 'Sabes que estoy colgando en tus manos');
INSERT INTO ARTISTA VALUES(TO_DATE('01/05/2002', 'DD/MM/YYYY'), 'Australiana', 'Adrianna', 'Stone');
INSERT INTO NOM_ARTISTA VALUES('AdriStar', 'Stone', 'Adrianna');
INSERT INTO GUIONITZA VALUES('Stone', 'Adrianna', '12');
INSERT INTO DIBUIXA VALUES('Stone', 'Adrianna', '12');
INSERT INTO SALO VALUES('Romance and fiction', 'Diciembre', 'Sidney');
INSERT INTO PREMI VALUES('Romances ficticios', 3, 'Mejor romance surrealista', 'Romance and fiction', 'Stone', 'Adrianna', TO_DATE('21/12/2017', 'DD/MM/YYYY'), '12');
INSERT INTO UBICACIO VALUES(2, 4, 6, 4, 9, '12');
INSERT INTO DISTR_CLIENT VALUES ('Romance, ficción y futurismo', 1, 570464609, 55558658, 13079, 'Reven', 'North Miami, 1959NE 153 ST');
INSERT INTO DISTR_CLIENT VALUES ('Romance', 0, 672478180, 319867833, 03145, 'Annabeth', 'Avenida el Dorado 68D');
INSERT INTO FACTURA VALUES (TO_DATE('15/06/2021', 'DD/MM/YYYY'),78.08, 1, 538535, 21, 55558658);
INSERT INTO FACTURA VALUES (TO_DATE('26/06/2021', 'DD/MM/YYYY'), 215.90, 0, 568533, 21, 319867833);
INSERT INTO LLISTA VALUES('1', 538535, 10, 5);
INSERT INTO LLISTA VALUES('12',568533, 15,3 );
INSERT INTO TICKET VALUES(1234, 300.95, 21, TO_DATE('04/05/2020', 'DD/MM/YYYY'), 489067541001);
INSERT INTO CONTE VALUES('12', 1234, 6, 21.95);
INSERT INTO PERSONATGE VALUES('Adrianna Michael', 'Cómico', 'Rubius', 'Humano', 'Era digital', 'Romántico', 'Ust', 'Principal');
INSERT INTO PERSONATGE VALUES ('Adrianna Michael', 'Cómico', 'Mangel','Humano', 'Era digital', 'Ciencia ficción', 'Rubius', 'Secundario');
INSERT INTO ACOMPANYA VALUES ('Rubius', 'Mangel');
INSERT INTO ESTA VALUES('Rubius', '12');


INSERT INTO EDITORIAL VALUES ('Kus Cruz', 'Purificacion Pulmon Izquierdo', 'Carrer dels amics');
INSERT INTO COLECCIO VALUES('Revista', 'Lejano Oeste', 'Max Verstappen', 'Divulgación', 'Cuentame, como te ha ido, si has conocido la felicidad', 0, 4, 2, TO_DATE('1/01/2012', 'DD/MM/YYYY'), 'Portugues',TO_DATE('12/07/2011', 'DD/MM/YYYY'));
INSERT INTO PRODUCTE VALUES('0008', '23');
INSERT INTO REV_PUBLI VALUES('Divulgación', 'Estopa', 431561361345, 'Alibaba i unos cuantos ladrones', 5, 'Finés', 'Revista', '0008', 'Purificacion Pulmon Izquierdo', 'Cuentame, como te ha ido, si has conocido la felicidad');
INSERT INTO ARTISTA VALUES(TO_DATE('15/12/2001', 'DD/MM/YYYY'), 'Canadiense', 'Jorge', 'Kluní');
INSERT INTO NOM_ARTISTA VALUES('0 friends', 'Kluní', 'Jorge');
INSERT INTO GUIONITZA VALUES('Kluní', 'Jorge', '0008');
INSERT INTO DIBUIXA VALUES('Kluní', 'Jorge', '0008');
INSERT INTO SALO VALUES('Pulpo ficción', 'Julio', 'Kamchatka');
INSERT INTO PREMI VALUES('Divulgación', 4, 'Y quien te ha preguntado? Edición Delux', 'Pulpo ficción', 'Kluní', 'Jorge', TO_DATE('11/09/2003', 'DD/MM/YYYY'), '0008');
INSERT INTO UBICACIO VALUES(9, 2,9, 1,34, '0008');
INSERT INTO DISTR_CLIENT VALUES ('Since I dont have you GR', 1, 3141592, 234234234234234, 75464, 'Fito i Fitipaldis', 'En algun lugar de la mancha cuyo nombre no quiero acordarme');
INSERT INTO DISTR_CLIENT VALUES ('Matemática e informática', 0, 672589280, 7654754327653, 43631, 'Ikhea','Directo a tu corazón');
INSERT INTO FACTURA VALUES (TO_DATE('22/04/2019', 'DD/MM/YYYY'),428.3, 1, 58148245, 17, 234234234234234);
INSERT INTO FACTURA VALUES (TO_DATE('28/03/2019', 'DD/MM/YYYY'), 3586.90, 0, 738535, 17, 7654754327653);
INSERT INTO LLISTA VALUES('0008',58148245, 18.95, 30);
INSERT INTO TICKET VALUES(254, 42.95, 8, TO_DATE('05/11/2002', 'DD/MM/YYYY'), 7654754327653);
INSERT INTO CONTE VALUES('0008', 254, 3, 28.90);
INSERT INTO PERSONATGE VALUES('Jorge Kluní', 'Sexy', 'Angel', 'Catalan', 'Irlandia', 'Revista', 'Willyrex', 'Heroe');
INSERT INTO PERSONATGE VALUES ('Jorge Kluní', 'Niño', 'Tractor', 'Tractor tactico de combate', 'Africa', 'Revista', 'Cleopatra', 'Victima');
INSERT INTO ACOMPANYA VALUES ('Angel', 'Tractor');
INSERT INTO ESTA VALUES('Tractor', '0008');


INSERT INTO EDITORIAL VALUES('Cristiano Cruz', 'Etna', 'One Direction');
INSERT INTO COLECCIO VALUES('Sátira', 'Edad Media', 'Jimin', 'Wattpad', 'Oh Mon Amour, Je t aime!', 0, 5, 12, TO_DATE('12/12/2012', 'DD/MM/YYYY'), 'Esperanto', TO_DATE('11/11/2011', 'DD/MM/YYYY'));
INSERT INTO PRODUCTE VALUES('13', '3');
INSERT INTO PRODUCTE VALUES('31', '3');
INSERT INTO REV_PUBLI VALUES('Sátira', 'Maximilien de Robespierre', 49582746237, 'A veces debes pensar que no te pienso, mientras planeo quitarte la inseguridad a los besos', 6, 'Esperanto', 'Wattpad', '13', 'Etna', 'Oh Mon Amour, Je t aime!');
INSERT INTO REV_PUBLI VALUES('Sátira', 'Maximilien de Robespierre', 49582746237, 'A la luna le pregunto si estas bien cuando no estoy', 6, 'Esperanto', 'Wattpad', '31', 'Etna', 'Oh Mon Amour, Je t aime!');
INSERT INTO ARTISTA VALUES(TO_DATE('06/02/1966', 'DD/MM/YYYY'), 'Polaco', 'Rick', 'Astley');
INSERT INTO NOM_ARTISTA VALUES('Faker', 'Astley','Rick');
INSERT INTO GUIONITZA VALUES('Astley','Rick','13');
INSERT INTO DIBUIXA VALUES('Astley','Rick','13');
INSERT INTO DIBUIXA VALUES('Astley','Rick','31');
INSERT INTO SALO VALUES('Jojo', 'Noviembre', 'México DC');
INSERT INTO PREMI VALUES('Nuestro corazón', 3, 'Wattpad', 'Jojo', 'Astley', 'Rick',  TO_DATE('12/11/2013', 'DD/MM/YYYY'), '13');
INSERT INTO UBICACIO VALUES(9, 1,9, 1,34, '13');
INSERT INTO DISTR_CLIENT VALUES('BTS, One Direction, fanfics', 1, 683180802, 5776961234, 08917, 'Nicky Nicole', 'En las nubes de tu pelo');
INSERT INTO DISTR_CLIENT VALUES('Backstreet boys, spice girls, atomic kitten', 1, 6741792, 123581321, 07918, 'Trueno', 'Honjo Daichi Senior HS');
INSERT INTO FACTURA VALUES(TO_DATE('22/04/2019', 'DD/MM/YYYY'),534.3, 1, 58147245, 17, 5776961234);
INSERT INTO FACTURA VALUES (TO_DATE('28/02/2019', 'DD/MM/YYYY'), 198.90, 0, 134535, 17, 123581321);
INSERT INTO LLISTA VALUES('13',58147245, 16.95, 12);
INSERT INTO TICKET VALUES(213, 42.95, 8, TO_DATE('05/11/2020', 'DD/MM/YYYY'), NULL);
INSERT INTO CONTE VALUES('13', 213, 3, 28.90);
INSERT INTO PERSONATGE VALUES('Rick Astley', 'Simpático', 'Duki', 'Humano', 'Edad Media', 'Romance', 'Bizarap', 'Heroe');
INSERT INTO PERSONATGE VALUES ('Rick Astley', 'Guapa', 'Emilia', 'Humano', 'Edad Media', 'Romance', 'Bizarap', 'Heroe');
INSERT INTO ACOMPANYA VALUES ('Duki', 'Emilia');
INSERT INTO ESTA VALUES('Duki', '13');

INSERT INTO PREMI VALUES('Suspense', 5, 'Suspense intrigante', 'Agallas un perro cobarde', 'Astley', 'Rick', TO_DATE('10/04/2017', 'DD/MM/YYYY'), '13');

INSERT INTO PRODUCTE VALUES('14', '1');
INSERT INTO PRODUCTE VALUES('15', '3');
INSERT INTO PRODUCTE VALUES('16', '3');
INSERT INTO PRODUCTE VALUES('17', '6');
INSERT INTO PRODUCTE VALUES('18', '3');
INSERT INTO PRODUCTE VALUES('19', '4');
INSERT INTO PRODUCTE VALUES('20', '8');
INSERT INTO PRODUCTE VALUES('21', '3');
INSERT INTO PRODUCTE VALUES('22', '7');
INSERT INTO PRODUCTE VALUES('23', '2');

INSERT INTO FIGURES VALUES(20, 600, 'Pikachu', TO_DATE('05/09/2016', 'DD/MM/YYYY'), '14');
INSERT INTO FIGURES VALUES(20, 600, 'Squirle', TO_DATE('07/08/2016', 'DD/MM/YYYY'), '15');
INSERT INTO FIGURES VALUES(20, 600, 'Bulbasur', TO_DATE('23/09/2016', 'DD/MM/YYYY'), '16');
INSERT INTO FIGURES VALUES(20, 600, 'Charmander', TO_DATE('30/11/2016', 'DD/MM/YYYY'), '17');
INSERT INTO FIGURES VALUES(20, 600, 'Gyarados', TO_DATE('09/09/2016', 'DD/MM/YYYY'), '18');
INSERT INTO FIGURES VALUES(20, 600, 'Magikarp', TO_DATE('12/09/2016', 'DD/MM/YYYY'), '19');
INSERT INTO FIGURES VALUES(20, 600, 'Mewtwo', TO_DATE('26/11/2016', 'DD/MM/YYYY'), '20');
INSERT INTO FIGURES VALUES(20, 600, 'Serpentine', TO_DATE('14/09/2016', 'DD/MM/YYYY'), '21');
INSERT INTO FIGURES VALUES(20, 600, 'Pidgeot', TO_DATE('18/10/2016', 'DD/MM/YYYY'), '22');
INSERT INTO FIGURES VALUES(20, 600, 'Snorlax', TO_DATE('21/09/2016', 'DD/MM/YYYY'), '23');

INSERT INTO SUBMINISTRA VALUES('0001',77126633);
INSERT INTO SUBMINISTRA VALUES('0002',77987633);
INSERT INTO SUBMINISTRA VALUES('0003',76987633);
INSERT INTO SUBMINISTRA VALUES('0004',73987633);
INSERT INTO SUBMINISTRA VALUES('0005',739867833);
INSERT INTO SUBMINISTRA VALUES('1003',94325156);
INSERT INTO SUBMINISTRA VALUES('0007',66666099099);
INSERT INTO SUBMINISTRA VALUES('12',319867833);
INSERT INTO SUBMINISTRA VALUES('8',7654754327653);

INSERT INTO DISTR_CLIENT VALUES('-', 0, 66666666, 100000000, 07918, 'Adam', 'Calle Soledat num 13');

INSERT INTO SUBMINISTRA VALUES('14', 100000000);
INSERT INTO SUBMINISTRA VALUES('15', 100000000);
INSERT INTO SUBMINISTRA VALUES('16', 100000000);
INSERT INTO SUBMINISTRA VALUES('17', 100000000);
INSERT INTO SUBMINISTRA VALUES('18', 100000000);
INSERT INTO SUBMINISTRA VALUES('19', 100000000);
INSERT INTO SUBMINISTRA VALUES('20', 100000000);
INSERT INTO SUBMINISTRA VALUES('21', 100000000);
INSERT INTO SUBMINISTRA VALUES('22', 100000000);
INSERT INTO SUBMINISTRA VALUES('23', 100000000);


--1) La revista que nos ha dado más beneficios:
CREATE TABLE TAULA_AUX_VENTA AS
    SELECT AVG(LL.Preu_Unitat * LL.QUANT_EXEMPL) AS MIJANA, LL.PRODUCTE_CODI AS CODI
    FROM DISTR_CLIENT DC, LLISTA LL, FACTURA F
    WHERE DC.NIF = F.DISTR_CLIENT_NIF AND
        F.CODI = LL.FACTURA_CODI AND
        DC.ES_CLIENT = 0
    GROUP BY LL.PRODUCTE_CODI;
    

CREATE TABLE TAULA_AUX_COMPRA1 AS
    SELECT AVG(LL.Preu_Unitat * LL.QUANT_EXEMPL) AS MITJANA , LL.PRODUCTE_CODI AS CODI
    FROM DISTR_CLIENT DC, LLISTA LL, FACTURA F
    WHERE DC.NIF = F.DISTR_CLIENT_NIF AND
        F.CODI = LL.FACTURA_CODI AND
        DC.ES_CLIENT = 1
    GROUP BY LL.PRODUCTE_CODI;

CREATE TABLE TAULA_AUX_COMPRA2 AS
    SELECT AVG(PREU_UNITAT * QUAN_EXEMPL) AS MITJANA, PRODUCTE_CODI AS CODI
    FROM CONTE
    GROUP BY PRODUCTE_CODI;

SELECT MAX(C1.MITJANA + C2.MITJANA - V.MIJANA) AS GUANYANÇA_MAXIMA, R.TITOL
FROM TAULA_AUX_COMPRA1 C1, TAULA_AUX_COMPRA2 C2, TAULA_AUX_VENTA V, REV_PUBLI R
WHERE (C1.CODI = V.CODI OR
    C2.CODI = V.CODI) AND
    R.PRODUCTE_CODI = V.CODI
GROUP BY R.TITOL;

DROP TABLE TAULA_AUX_VENTA; 
DROP TABLE TAULA_AUX_COMPRA1;
DROP TABLE TAULA_AUX_COMPRA2;

--2) Nombre de los artistas que han ganado mas premios y cuantos premios:
SELECT A.Nom, count(P.edicio)
	FROM ARTISTA A, PREMI P
	WHERE A.Nom = P.Artista_Nom AND 
A.Cognom = P.Artista_Cognom 
group by A.nom
having count(P.edicio) >= all(select count(p.edicio) 
                                FROM ARTISTA A, PREMI P
                                WHERE A.Nom = P.Artista_Nom AND 
                                A.Cognom = P.Artista_Cognom 
                                group by A.nom );

---3) NIF de los clientes que han realizado la compra total más cara y el importe:
SELECT f.distr_client_nif, sum(f.preu)
FROM DISTR_Client C, FACTURA F
WHERE f.DISTR_CLIENT_NIF = c.nif AND
	c.Es_client = 1
group by f.DISTR_client_nif
having SUM(F.Preu) >= all (	SELECT sum(f.preu)
                    FROM DISTR_Client C, FACTURA F
                    WHERE f.DISTR_CLIENT_NIF = c.nif AND
                    c.Es_client = 1
                    group by f.DISTR_client_nif);

--4) Nacionalidad mas comuna entre los artistas y cuantas veces se repite
SELECT nacionalitat, count(nom)
FROM artista
GROUP BY nacionalitat
having count(nom) >= all( SELECT count(nom)
                    		FROM artista
                        	GROUP BY nacionalitat);
                            

--5) Autor de un libro en concreto: Pedro picapiedra
SELECT A.nom
FROM ARTISTA A, REV_PUBLI RP, guionitza g
WHERE A.NOM = G.ARTISTA_NOM AND
	A.COGNOM = G.ARTISTA_COGNOM AND
	G.REV_PUBLI_PRODUCTE_CODI = RP.PRODUCTE_CODI AND
	RP.TITOL = 'Pedro pica piedra';
    

--6) listado de los generos escritos por el autor lluís de menor a mayor
SELECT RP.Genere, count(RP.PRODUCTE_CODI) AS N_COPS--count(rp.producte_codi)
FROM REV_PUBLI RP, GUIONITZA G, ARTISTA A
WHERE A.NOM = G.artista_NOM AND
	A.COGNOM = G.artista_COGNOM AND
	G.REV_PUBLI_PRODUCTE_CODI = RP.PRODUCTE_CODI AND
	A.NOM = 'Lluís'
group by RP.Genere
ORDER BY 2, 1;


--7) dibuixant que en més llibres ha participat:
SELECT A.NOM, A.COGNOM, count(rp.producte_codi)
FROM artista a, rev_publi rp, dibuixa d
where a.nom = d.artista_nom and
	a.cognom = d.artista_cognom and
	D.rev_publi_producte_codi = rp.producte_codi
group by a.nom, A.COGNOM
having count(RP.PRODUCTE_CODI) >= all( SELECT count(rp.producte_codi)
                                            from artista a, rev_publi rp, dibuixa d
                                            where a.nom = d.artista_nom and
                                                a.cognom = d.artista_cognom and
                                                D.rev_publi_producte_codi = rp.producte_codi
                                            group by a.nom, A.COGNOM);

--8) Llibres romàntics que tenim
SELECT  TITOL
FROM REV_PUBLI
WHERE GENERE = 'Romance';

--9) Com podem trobar l'exemplar del producte associat a la ID 3:

SELECT U.fila, u.sala, u.estant, u.columna
FROM PRODUCTE P, UBICACIO U
WHERE P.codi = '0003' and
		P.codi  = U.Producte_codi;
        
--10) Coleccio mes peque:
SELECT nom, volumns
FROM Coleccio
WHERE volumns <= all(SELECT volumns
							FROM Coleccio);


--11) Factura més recent:
SELECT CODI, DATA
FROM FACTURA
WHERE DATA >= ALL (SELECT DATA FROM FACTURA);

--12) Revistes que hem de reposar:
SELECT RP.TITOL 
FROM REV_PUBLI RP, PRODUCTE P
WHERE P.CODI = RP.PRODUCTE_CODI AND
P.STOCK = 0;

--13) Quina ha estat la revista més venuda per ticket:
SELECT RP.TITOL, SUM(C.Quan_Exempl)
FROM REV_PUBLI RP, CONTE C
WHERE RP.PRODUCTE_CODI = C.PRODUCTE_CODI 
group by RP.TITOL
having SUM(C.Quan_Exempl) >= all(SELECT SUM(C.Quan_Exempl)
                                FROM REV_PUBLI RP, CONTE C
                                WHERE RP.PRODUCTE_CODI = C.PRODUCTE_CODI 
                                group by RP.TITOL);
                                
--14) Codi postal més comú
SELECT C_POSTAL, count(C_Postal) 
FROM Distr_Client
WHERE es_client = 1
group by C_Postal
having count(C_Postal) >= all(SELECT count(C_Postal) 
    				FROM Distr_Client
					WHERE es_client = 1
					group by C_Postal);

--15) Quins dies es realitzen més compres de la  setmana i els imports: (NOMES PER TICKETS)
SELECT to_char(data, 'DAY'), count(codi) as n_cops, sum(preu) as preu_total
from ticket
group by to_char(data, 'DAY')
order by 2,3,1; 

--16) Guanys i pèrdues mensuals: 

--HISTOGRAMA
CREATE TABLE TAULA_AUX_COMPRA AS
        SELECT to_char(F.data, 'MM/YYYY') AS MES, sum(f.preu) as preu_total
        FROM factura F, distr_client DC
        WHERE DC.ES_CLIENT = 0 AND
                F.DISTR_CLIENT_NIF = DC.NIF
        GROUP BY to_char(F.data, 'MM/YYYY');
        
CREATE TABLE TAULA_AUX_VENTA1 AS
        SELECT to_char(F.data, 'MM/YYYY') AS MES, sum(f.preu) as preu_total
        FROM factura F, distr_client DC
        WHERE DC.ES_CLIENT = 1 AND
                F.DISTR_CLIENT_NIF = DC.NIF
        GROUP BY to_char(F.data, 'MM/YYYY');
        
CREATE TABLE TAULA_AUX_VENTA2 AS
        SELECT to_char(data, 'MM/YYYY') AS MES, sum(preu) as preu_total
        FROM TICKET
        GROUP BY to_char(data, 'MM/YYYY');

        
    
SELECT V1.PREU_TOTAL + V2.PREU_TOTAL - C.PREU_TOTAL AS BENEFICIS, C.MES
FROM TAULA_AUX_COMPRA C, TAULA_AUX_VENTA1 V1, TAULA_AUX_VENTA2 V2
WHERE C.MES = V1.MES AND
    C.MES = V2.MES;
    
DROP TABLE TAULA_AUX_COMPRA;
DROP TABLE TAULA_AUX_VENTA1;
DROP TABLE TAULA_AUX_VENTA2;

--ULTIM MES
--17)
CREATE TABLE TAULA_AUX_COMPRA AS
        SELECT to_char(F.data, 'MM/YYYY') AS MES, sum(f.preu) as preu_total
        FROM factura F, distr_client DC
        WHERE DC.ES_CLIENT = 0 AND
                F.DISTR_CLIENT_NIF = DC.NIF AND
                to_char(F.data, 'MM/YYYY') = '11/2021'
        GROUP BY to_char(F.data, 'MM/YYYY');
        
CREATE TABLE TAULA_AUX_VENTA1 AS
        SELECT to_char(F.data, 'MM/YYYY') AS MES, sum(f.preu) as preu_total
        FROM factura F, distr_client DC
        WHERE DC.ES_CLIENT = 1 AND
                F.DISTR_CLIENT_NIF = DC.NIF AND
                to_char(F.data, 'MM/YYYY') = '11/2021'
        GROUP BY to_char(F.data, 'MM/YYYY');
        
CREATE TABLE TAULA_AUX_VENTA2 AS
        SELECT to_char(data, 'MM/YYYY') AS MES, sum(preu) as preu_total
        FROM TICKET
        WHERE to_char(data, 'MM/YYYY') = '11/2021'
        GROUP BY to_char(data, 'MM/YYYY');

        
    
SELECT V1.PREU_TOTAL + V2.PREU_TOTAL - C.PREU_TOTAL AS BENEFICIS
FROM TAULA_AUX_COMPRA C, TAULA_AUX_VENTA1 V1, TAULA_AUX_VENTA2 V2;

    
DROP TABLE TAULA_AUX_COMPRA;
DROP TABLE TAULA_AUX_VENTA1;
DROP TABLE TAULA_AUX_VENTA2;


--18)

-- VOLEM LLEVAR UN PRODUCTE AMD ID '0001' DE LA UBICACIO (FILA = 3, SALA = 4, ESTANT = 7, COLUMNA = 5)
SELECT
        CASE WHEN NUM_UNITATS < 2 THEN 'Te has quedado sin Stock en esta ubicación.'
        END as notificacion
    FROM UBICACIO WHERE FILA = 3 AND SALA = 4 AND ESTANT = 7 AND COLUMNA = 5;
UPDATE UBICACIO
SET NUM_UNITATS = NUM_UNITATS-1
WHERE FILA = 3 AND
        SALA = 4 AND
        ESTANT = 7 AND
        COLUMNA = 5;

UPDATE PRODUCTE
SET STOCK = STOCK-1
WHERE CODI = '0001';

-- L'AFEGIM
UPDATE UBICACIO
SET NUM_UNITATS = NUM_UNITATS+1
WHERE FILA = 3 AND
        SALA = 4 AND
        ESTANT = 7 AND
        COLUMNA = 5;
UPDATE PRODUCTE
SET STOCK = STOCK+1
WHERE CODI = '0001';