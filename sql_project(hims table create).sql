CREATE TABLE gender (
    genderid INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    status BOOLEAN DEFAULT TRUE,
    addedby INTEGER,
    addeddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedby BIGINT,
    updateddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE nationality (
    nationalityid INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    status BOOLEAN DEFAULT TRUE,
    addedby INTEGER,
    addeddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedby INTEGER,
    updateddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE country (
    countryid INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    nationalityid INTEGER,
    status BOOLEAN DEFAULT TRUE,
    addedby INTEGER,
    addeddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedby BIGINT,
    updateddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_country_nationality
        FOREIGN KEY (nationalityid) REFERENCES nationality(nationalityid)
);

CREATE TABLE state (
    stateid INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    countryid INTEGER,
    status BOOLEAN DEFAULT TRUE,
    addedby INTEGER,
    addeddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedby BIGINT,
    updateddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_state_country
        FOREIGN KEY (countryid) REFERENCES country(countryid)
);

CREATE TABLE city (
    cityid INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    stateid INTEGER NOT NULL,
    status BOOLEAN DEFAULT TRUE,
    addedby INTEGER,
    addeddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedby BIGINT,
    updateddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_city_state
        FOREIGN KEY (stateid) REFERENCES state(stateid)
);
CREATE TABLE department (
    departmentid INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    isclinical BOOLEAN NOT NULL,
    status BOOLEAN DEFAULT TRUE,
    addedby INTEGER,
    addeddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedby BIGINT,
    updateddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE unit (
    unitid INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    status BOOLEAN DEFAULT TRUE,
    addedby INTEGER,
    addeddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedby BIGINT,
    updateddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ward (
    wardid INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    unitid INTEGER,
    status BOOLEAN DEFAULT TRUE,
    addedby INTEGER,
    addeddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedby BIGINT,
    updateddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_ward_unit
        FOREIGN KEY (unitid) REFERENCES unit(unitid)
);

CREATE TABLE room (
    roomid INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    wardid INTEGER NOT NULL,
    status BOOLEAN DEFAULT TRUE,
    addedby INTEGER,
    addeddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedby BIGINT,
    updateddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_room_ward
        FOREIGN KEY (wardid) REFERENCES ward(wardid)
);

CREATE TABLE bed (
    bedid INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    wardid INTEGER,
    roomid INTEGER,
    status BOOLEAN DEFAULT TRUE,
    addedby INTEGER,
    addeddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedby BIGINT,
    updateddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_bed_room
        FOREIGN KEY (roomid) REFERENCES room(roomid)
);
CREATE TABLE patientcategory (
    patientcategoryid INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    status BOOLEAN DEFAULT TRUE,
    addedby INTEGER,
    addeddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedby BIGINT,
    updateddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE relation (
    relationid INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    status BOOLEAN DEFAULT TRUE,
    addedby INTEGER,
    addeddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedby BIGINT,
    updateddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE patient (
    patientid BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    firstname VARCHAR(150) NOT NULL,
    middlename VARCHAR(150),
    lastname VARCHAR(150) NOT NULL,
    genderid INTEGER NOT NULL,
    dateofbirth DATE,
    contactno1 VARCHAR(15),
    contactno2 VARCHAR(15),
    email VARCHAR(100),
    addressline1 VARCHAR(150),
    addressline2 VARCHAR(150),
    pincode VARCHAR(10),
    cityid INTEGER,
    status BOOLEAN DEFAULT TRUE,
    addedby INTEGER,
    addeddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedby BIGINT,
    updateddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_patient_gender FOREIGN KEY (genderid) REFERENCES gender(genderid),
    CONSTRAINT fk_patient_city FOREIGN KEY (cityid) REFERENCES city(cityid)
);
CREATE TABLE staff (
    staffid BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    departmentid INTEGER NOT NULL,
    firstname VARCHAR(150) NOT NULL,
    middlename VARCHAR(150),
    lastname VARCHAR(150) NOT NULL,
    genderid INTEGER NOT NULL,
    dateofbirth DATE,
    contactno1 VARCHAR(15),
    contactno2 VARCHAR(15),
    email VARCHAR(100),
    addressline1 VARCHAR(150),
    addressline2 VARCHAR(150),
    pincode VARCHAR(10),
    cityid INTEGER,
    status BOOLEAN DEFAULT TRUE,
    addedby INTEGER,
    addeddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedby BIGINT,
    updateddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_staff_department FOREIGN KEY (departmentid) REFERENCES department(departmentid),
    CONSTRAINT fk_staff_gender FOREIGN KEY (genderid) REFERENCES gender(genderid),
    CONSTRAINT fk_staff_city FOREIGN KEY (cityid) REFERENCES city(cityid)
);

CREATE TABLE "user" (
    userid BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    staffid BIGINT NOT NULL,
    status BOOLEAN DEFAULT TRUE,
    addedby INTEGER,
    addeddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedby BIGINT,
    updateddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_user_staff FOREIGN KEY (staffid) REFERENCES staff(staffid)
);
CREATE TABLE doctor (
    doctorid BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    departmentid INTEGER NOT NULL,
    firstname VARCHAR(150) NOT NULL,
    middlename VARCHAR(150),
    lastname VARCHAR(150) NOT NULL,
    qualification VARCHAR(150),
    genderid INTEGER,
    dateofbirth DATE,
    contactno1 VARCHAR(15),
    contactno2 VARCHAR(15),
    email VARCHAR(100),
    addressline1 VARCHAR(150),
    addressline2 VARCHAR(150),
    pincode VARCHAR(10),
    cityid INTEGER,
    status BOOLEAN DEFAULT TRUE,
    addedby INTEGER,
    addeddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedby BIGINT,
    updateddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_doctor_department FOREIGN KEY (departmentid) REFERENCES department(departmentid),
    CONSTRAINT fk_doctor_gender FOREIGN KEY (genderid) REFERENCES gender(genderid),
    CONSTRAINT fk_doctor_city FOREIGN KEY (cityid) REFERENCES city(cityid)
);
CREATE TABLE visit (
    visitid BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    patientcategoryid INTEGER NOT NULL,
    patientid BIGINT NOT NULL,
    doctorid BIGINT NOT NULL,
    unitid INTEGER NOT NULL,
    visitdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    opdnumber BIGINT NOT NULL,
    status BOOLEAN DEFAULT TRUE,
    addedby INTEGER,
    addeddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedby BIGINT,
    updateddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_visit_patient FOREIGN KEY (patientid) REFERENCES patient(patientid),
    CONSTRAINT fk_visit_doctor FOREIGN KEY (doctorid) REFERENCES doctor(doctorid),
    CONSTRAINT fk_visit_unit FOREIGN KEY (unitid) REFERENCES unit(unitid),
    CONSTRAINT fk_visit_category FOREIGN KEY (patientcategoryid) REFERENCES patientcategory(patientcategoryid)
);

CREATE TABLE admission (
    admissionid BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    patientcategoryid INTEGER NOT NULL,
    patientid BIGINT NOT NULL,
    unitid INTEGER NOT NULL,
    doctorid BIGINT NOT NULL,
    admissiondate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ipdnumber BIGINT NOT NULL,
    relativename VARCHAR(200),
    relationid INTEGER,
    bedid INTEGER NOT NULL,
    companyid INTEGER NOT NULL,
    ismlc BOOLEAN,
    status BOOLEAN DEFAULT TRUE,
    addedby INTEGER,
    addeddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedby BIGINT,
    updateddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_admission_patient FOREIGN KEY (patientid) REFERENCES patient(patientid),
    CONSTRAINT fk_admission_doctor FOREIGN KEY (doctorid) REFERENCES doctor(doctorid),
    CONSTRAINT fk_admission_bed FOREIGN KEY (bedid) REFERENCES bed(bedid),
    CONSTRAINT fk_admission_unit FOREIGN KEY (unitid) REFERENCES unit(unitid),
    CONSTRAINT fk_admission_relation FOREIGN KEY (relationid) REFERENCES relation(relationid)
);

CREATE TABLE discharge (
    dischargeid BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    admissionid BIGINT NOT NULL,
    doctorid BIGINT NOT NULL,
    dischargedate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dischargenotes TEXT,
    fileattachedpath VARCHAR(500),
    status BOOLEAN DEFAULT TRUE,
    addedby INTEGER,
    addeddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedby BIGINT,
    updateddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_discharge_admission FOREIGN KEY (admissionid) REFERENCES admission(admissionid),
    CONSTRAINT fk_discharge_doctor FOREIGN KEY (doctorid) REFERENCES doctor(doctorid)
);
CREATE TABLE insurancecompany (
    companyid INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    status BOOLEAN DEFAULT TRUE,
    addedby INTEGER,
    addeddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedby BIGINT,
    updateddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE servicecategory (
    servicecategoryid INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    status BOOLEAN DEFAULT TRUE,
    addedby INTEGER,
    addeddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedby BIGINT,
    updateddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE servicetype (
    servicetypeid INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50),
    status BOOLEAN DEFAULT TRUE,
    addedby INTEGER,
    addeddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedby BIGINT,
    updateddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE service (
    serviceid BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    servicecategoryid INTEGER NOT NULL,
    rate NUMERIC(18,2) NOT NULL,
    servicetypeid INTEGER NOT NULL,
    companyid INTEGER,
    status BOOLEAN DEFAULT TRUE,
    addedby INTEGER,
    addeddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedby BIGINT,
    updateddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_service_category FOREIGN KEY (servicecategoryid) REFERENCES servicecategory(servicecategoryid),
    CONSTRAINT fk_service_type FOREIGN KEY (servicetypeid) REFERENCES servicetype(servicetypeid),
    CONSTRAINT fk_service_company FOREIGN KEY (companyid) REFERENCES insurancecompany(companyid)
);
CREATE VIEW view_servicedetails AS
SELECT
    st.name AS servicetype,
    sc.name AS servicecategory,
    s.name AS servicename,
    s.rate,
    s.companyid
FROM service s
JOIN servicecategory sc ON s.servicecategoryid = sc.servicecategoryid
JOIN servicetype st ON s.servicetypeid = st.servicetypeid;

CREATE VIEW view_patient AS
SELECT
    p.patientid,
    p.firstname,
    p.middlename,
    p.lastname,
    g.name AS gender,
    p.dateofbirth,
    p.contactno1,
    p.contactno2,
    p.email,
    p.addressline1,
    p.addressline2,
    p.pincode,
    c.name AS city
FROM patient p
JOIN gender g ON p.genderid = g.genderid
JOIN city c ON p.cityid = c.cityid;

CREATE VIEW view_doctor AS
SELECT
    d.doctorid,
    d.firstname,
    d.middlename,
    d.lastname,
    d.qualification,
    dp.name AS department,
    g.name AS gender,
    d.dateofbirth,
    d.contactno1,
    d.contactno2,
    d.email,
    d.addressline1,
    d.addressline2,
    d.pincode,
    c.name AS city
FROM doctor d
JOIN gender g ON d.genderid = g.genderid
JOIN city c ON d.cityid = c.cityid
JOIN department dp ON d.departmentid = dp.departmentid;

CREATE VIEW view_staff AS
SELECT
    s.staffid,
    s.firstname,
    s.middlename,
    s.lastname,
    dp.name AS department,
    g.name AS gender,
    s.dateofbirth,
    s.contactno1,
    s.contactno2,
    s.email,
    s.addressline1,
    s.addressline2,
    s.pincode,
    c.name AS city
FROM staff s
JOIN gender g ON s.genderid = g.genderid
JOIN city c ON s.cityid = c.cityid
JOIN department dp ON s.departmentid = dp.departmentid;




-- 1. ApplicationFunctionality
CREATE TABLE applicationfunctionality (
    functionalityid BIGSERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    level INT NOT NULL,
    status BOOLEAN DEFAULT TRUE,
    addedby INT,
    addeddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedby BIGINT,
    updateddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. AccessRights
CREATE TABLE accessrights (
    accessrightid BIGSERIAL PRIMARY KEY,
    userid BIGINT NOT NULL,
    functionalityid BIGINT NOT NULL,
    status BOOLEAN DEFAULT TRUE,
    addedby INT,
    addeddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedby BIGINT,
    updateddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_accessrights_user
        FOREIGN KEY (userid) REFERENCES "user"(userid),
    CONSTRAINT fk_accessrights_functionality
        FOREIGN KEY (functionalityid) REFERENCES applicationfunctionality(functionalityid)
);

-- 3. Advance
CREATE TABLE advance (
    advanceid BIGSERIAL PRIMARY KEY,
    patientid BIGINT NOT NULL,
    advamount NUMERIC(18,2),
    used NUMERIC(18,2),
    refund NUMERIC(18,2),
    balance NUMERIC(18,2),
    status BOOLEAN DEFAULT TRUE,
    addedby INT,
    addeddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedby BIGINT,
    updateddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_advance_patient
        FOREIGN KEY (patientid) REFERENCES patient(patientid)
);

-- 4. Bill
CREATE TABLE bill (
    billid BIGSERIAL PRIMARY KEY,
    billdatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    visitid BIGINT,
    admissionid BIGINT,
    totalamount NUMERIC(18,2),
    advanceamount NUMERIC(18,2),
    concession NUMERIC(18,2),
    finalbillamount NUMERIC(18,2),
    status BOOLEAN DEFAULT TRUE,
    addedby INT,
    addeddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedby BIGINT,
    updateddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_bill_visit
        FOREIGN KEY (visitid) REFERENCES visit(visitid),
    CONSTRAINT fk_bill_admission
        FOREIGN KEY (admissionid) REFERENCES admission(admissionid)
);

-- 5. Charge
CREATE TABLE charge (
    chargeid BIGSERIAL PRIMARY KEY,
    visitid BIGINT,
    admissionid BIGINT,
    serviceid BIGINT NOT NULL,
    rate NUMERIC(18,2) NOT NULL,
    quantity INT NOT NULL,
    amount NUMERIC(18,2) NOT NULL,
    concession NUMERIC(18,2),
    status BOOLEAN DEFAULT TRUE,
    addedby INT,
    addeddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedby BIGINT,
    updateddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_charge_visit
        FOREIGN KEY (visitid) REFERENCES visit(visitid),
    CONSTRAINT fk_charge_admission
        FOREIGN KEY (admissionid) REFERENCES admission(admissionid),
    CONSTRAINT fk_charge_service
        FOREIGN KEY (serviceid) REFERENCES service(serviceid)
);

-- 6. Prescription
CREATE TABLE prescription (
    prescriptionid BIGSERIAL PRIMARY KEY,
    visitid BIGINT NOT NULL,
    path VARCHAR(500),
    status BOOLEAN DEFAULT TRUE,
    addedby INT,
    addeddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedby BIGINT,
    updateddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_prescription_visit
        FOREIGN KEY (visitid) REFERENCES visit(visitid)
);

-- 7. ClinicalNote
CREATE TABLE clinicalnote (
    clinicalnoteid BIGSERIAL PRIMARY KEY,
    admissionid BIGINT NOT NULL,
    path VARCHAR(500),
    status BOOLEAN DEFAULT TRUE,
    addedby INT,
    addeddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedby BIGINT,
    updateddatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_clinicalnote_admission
        FOREIGN KEY (admissionid) REFERENCES admission(admissionid)
);
