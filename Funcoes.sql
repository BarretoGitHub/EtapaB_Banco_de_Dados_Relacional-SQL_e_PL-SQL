 

-- EXERCÍCIO 1 --
/*  Faça uma função que, dado o id do empregado, retorne a quantidade de anos completos que ele trabalha na empresa.*/

CREATE OR REPLACE FUNCTION anos_emp (
    empregado_id employees.employee_id%TYPE
) RETURN NUMBER IS
    qtd   NUMBER;
BEGIN
    SELECT
        trunc(months_between(SYSDATE, hire_date) / 12)
    INTO qtd
    FROM
        employees
    WHERE
        employee_id = empregado_id;

    RETURN qtd;
END;
/

BEGIN
    dbms_output.put_line('ANOS NA EMPRESA: ' || anos_emp(104));
END;
/

-- EXERCÍCIO 2
-- Faça uma função que, dado o id do empregado, retorne quantos empregados são mais antigos que ele na empresa.

CREATE OR REPLACE FUNCTION f_data (
    emp_id employees.employee_id%TYPE
) RETURN NUMBER IS
    quantidade   NUMBER;
BEGIN
    SELECT
        COUNT(employee_id)
    INTO quantidade
    FROM
        employees
    WHERE
        trunc(months_between(SYSDATE, hire_date) / 12) > (
            SELECT
                trunc(months_between(SYSDATE, hire_date) / 12)
            FROM
                employees
            WHERE
                employee_id = emp_id
        );

    RETURN quantidade;
END;
/

BEGIN
    dbms_output.put_line('QUANTIDADE DE FUNCIONÁRIOS : ' || f_data(104));
END;
/


 
-- EXERCÍCIO 3

CREATE OR REPLACE FUNCTION status_emp (
    emp_id employees.employee_id%TYPE
) RETURN VARCHAR2 IS
    status     VARCHAR2(10);
    qtd_anos   NUMBER;
BEGIN
    SELECT
        trunc(months_between(SYSDATE, hire_date) / 12)
    INTO qtd_anos
    FROM
        employees
    WHERE
        employee_id = emp_id;

    IF qtd_anos > 12 THEN
        status := 'MASTER';
    ELSIF qtd_anos > 8 THEN
        status := 'SENIOR';
    ELSE
        status := 'PLENO';
    END IF;

    RETURN status;
END;
/

SELECT
    employee_id,
    first_name   "NOME",
    last_name    "SOBRENOME",
    status_emp(employee_id) "STATUS"
FROM
    employees
WHERE
    status_emp(employee_id) = 'SENIOR';

SELECT
    employee_id,
    first_name   "NOME",
    last_name    "SOBRENOME",
    status_emp(employee_id) "STATUS"
FROM
    employees
WHERE
    status_emp(employee_id) = 'MASTER';

SELECT
    employee_id,
    first_name   "NOME",
    last_name    "SOBRENOME",
    status_emp(employee_id) "STATUS"
FROM
    employees;

SELECT
    first_name,
    last_name,
    status_emp(employee_id)
FROM
    employees
WHERE
    employee_id = 104;