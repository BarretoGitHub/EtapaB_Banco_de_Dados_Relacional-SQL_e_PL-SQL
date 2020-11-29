-- EXERCÍCIO 1 --
/*
Defina um procedimento que informe na tela quais os empregados que podem receber aumento, dependendo do id do gerente. 
Imprima na tela nome e salário dos empregados que podem receber aumento. Podem receber aumento os empregados cujo 
salário for menor do que 5000 e que tenham manager_id igual a 101 ou 124. 
Torne o procedimento genérico, passando o id do gerente e o limite superior de salário como parâmetros. Use cursor com parâmetros.
*/
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE ajuste (
    e_manager_id_1   IN               employees.manager_id%TYPE,
    e_manager_id_2   IN               employees.manager_id%TYPE,
    e_salary         IN               employees.salary%TYPE
) AS

    e_first_name   employees.first_name%TYPE;
    e_salary_      employees.salary%TYPE;
    CURSOR c_ajuste (
        e_manager_id_1   employees.manager_id%TYPE,
        e_manager_id_2   employees.manager_id%TYPE,
        e_salary         employees.salary%TYPE
    ) IS
    SELECT
        e.first_name,
        e.salary
    FROM
        employees e
    WHERE
        e.salary < e_salary
        AND ( e.manager_id = e_manager_id_1
              OR e.manager_id = e_manager_id_2 );

BEGIN
    OPEN c_ajuste(e_manager_id_1, e_manager_id_2, e_salary);
    LOOP
        FETCH c_ajuste INTO
            e_first_name,
            e_salary_;
        EXIT WHEN c_ajuste%notfound;
        dbms_output.put_line('NOME: '
                             || upper(e_first_name)
                             || ' SALÁRIO: R$'
                             || e_salary_);

    END LOOP;

    CLOSE c_ajuste;
END;
/

BEGIN
    ajuste(101, 124, 5000);
END;
/

-- EXERCÍCIO 2 --
/*
O departamento de IT, localizado no estado americano do Texas, fica próximo de uma estação de exploração petrolífera e, 
devido a uma lei regulamentada nos EUA, os funcionários devem receber um adicional de 20% no salário devido à periculosidade. 
Elabore um procedimento que informe na tela o nome e sobrenome do empregado, qual o nome do departamento onde trabalha e 
o valor do adicional de periculosidade, considerando somente os empregados que possuem esse direito.
*/

CREATE OR REPLACE PROCEDURE depart AS

    first_name_e        employees.first_name%TYPE;
    last_name_e         employees.last_name%TYPE;
    periculosidade_e    employees.salary%TYPE;
    department_name_e   departments.department_name%TYPE;
    CURSOR c_depart IS
    SELECT
        e.first_name,
        e.last_name,
        d.department_name,
        e.salary * 0.2 periculosidade
    FROM
        employees e,
        departments d,
        locations l
    WHERE
        d.department_name = 'IT'
        AND e.department_id = d.department_id
        AND upper(l.state_province) = 'TEXAS'
        AND upper(l.country_id) = 'US'
        AND l.location_id = d.location_id;

BEGIN
    OPEN c_depart;
    LOOP
        FETCH c_depart INTO
            first_name_e,
            last_name_e,
            department_name_e,
            periculosidade_e;
        EXIT WHEN c_depart%notfound;
        dbms_output.put_line('NOME E SOBRENOME: '
                             || first_name_e
                             || '  '
                             || last_name_e
                             || ' DEPARTAMENTO: '
                             || department_name_e
                             || ' PERICULOSIDADE '
                             || periculosidade_e);

    END LOOP;

    CLOSE c_depart;
END;
/

BEGIN
    depart;
END;
/

-- EXERCÍCIO 3 --
/* Utilize uma cópia da tabela EMPLOYEES chamada EMP. Efetue uma alteração na tabela EMP adicionando uma coluna denominada “dangerousness” 
(periculosidade). Estenda o exercício anterior com instruções para atualizar tal coluna com o valor de periculosidade, 
no caso dos empregados que possuam esse direito. 

Torne o procedimento genérico, passando o nome do departamento e nome do estado como parâmetros. 
 */

CREATE TABLE emp
    AS
        SELECT
            *
        FROM
            employees;

ALTER TABLE emp ADD dangerousness NUMBER(8, 2);

CREATE OR REPLACE PROCEDURE depart (
    v_department_name   departments.department_name%TYPE,
    v_state_province    locations.state_province%TYPE,
    v_country_id        locations.country_id%TYPE
) AS

    CURSOR c_depart IS
    SELECT
        e.employee_id,
        e.first_name,
        e.last_name,
        d.department_name,
        e.salary * 0.2 periculosidade
    FROM
        employees e,
        departments d,
        locations l
    WHERE
        d.department_name = v_department_name
        AND e.department_id = d.department_id
        AND upper(l.state_province) = v_state_province
        AND upper(l.country_id) = v_country_id
        AND l.location_id = d.location_id;

    r_emp   c_depart%rowtype;
BEGIN
    OPEN c_depart;
    LOOP
        FETCH c_depart INTO r_emp;
        EXIT WHEN c_depart%notfound;
        dbms_output.put_line('NOME E SOBRENOME: '
                             || r_emp.first_name
                             || '  '
                             || r_emp.last_name
                             || ' DEPARTAMENTO: '
                             || r_emp.department_name
                             || ' PERICULOSIDADE '
                             || r_emp.periculosidade);

        UPDATE emp
        SET
            dangerousness = r_emp.periculosidade
        WHERE
            employee_id = r_emp.employee_id;

    END LOOP;

    CLOSE c_depart;
END;
/

BEGIN
    depart('IT', 'TEXAS', 'US');
END;
/

SELECT * FROM  emp;