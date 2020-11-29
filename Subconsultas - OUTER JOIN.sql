--1.	Selecione o nome, sobrenome e nome do departamento de todos funcionários, incluindo os funcionários que não estão em nenhum departamento.
SELECT
    first_name,
    last_name,
    department_name
FROM
    employees
    LEFT OUTER JOIN departments ON employees.department_id = departments.department_id;
--
--2.	Selecione o nome, sobrenome e nome do departamento de todos funcionários, incluindo os departamentos que não possuem funcionários.
--

SELECT
    first_name,
    last_name,
    department_name
FROM
    employees
    RIGHT OUTER JOIN departments ON employees.department_id = departments.department_id;
--
--3.	Selecione o nome, sobrenome e nome do departamento de todos funcionários, incluindo os funcionários que não estão em nenhum departamento e os departamentos que não possuem funcionários.

SELECT
    first_name,
    last_name,
    department_name
FROM
    employees
    FULL OUTER JOIN departments ON employees.department_id = departments.department_id;
--
--4.	Selecione o nome, sobrenome e sobrenome do gerente de todos funcionários, incluindo os funcionários que não possuem gerente.

SELECT
    e.first_name,
    e.last_name,
    m.last_name   manager
FROM
    employees e
    LEFT OUTER JOIN employees m ON e.manager_id = m.employee_id;
--
--5.	Selecione o nome, sobrenome e nome da função (job_title) de todos funcionários, incluindo os nomes das funções que não possuem funcionários.

SELECT
    first_name,
    last_name,
    job_title
FROM
    employees
    RIGHT OUTER JOIN jobs ON employees.job_id = jobs.job_id;
--
--6.	Selecione o nome do departamento e nome do gerente do departamento, incluindo os departamentos que não possuem gerentes.

SELECT
    department_name,
    first_name,
    last_name
FROM
    departments
    LEFT OUTER JOIN employees ON departments.manager_id = employees.employee_id;
--
--7.	Selecione o nome do departamento e nome do gerente do departamento, incluindo os departamentos que não possuem gerentes.
--repetida
--8.	Selecione o nome do departamento e nome da cidade onde está localizado, incluindo os departamentos que não estão associados a nenhuma localização.

SELECT
    department_name,
    city
FROM
    departments
    LEFT OUTER JOIN locations ON departments.location_id = locations.location_id;
--
--9.	Selecione o nome do departamento e nome da cidade onde está localizado, incluindo as localizações que não estão associadas a nenhum departamento.

SELECT
    department_name,
    city
FROM
    departments
    RIGHT OUTER JOIN locations ON departments.location_id = locations.location_id;
--
--10.	Selecione o id da localização, o nome da cidade e o nome do país, incluindo os países que não estão associados a nenhuma localização.

SELECT
    department_name,
    city,
    country_name
FROM
    departments
    INNER JOIN locations ON departments.location_id = locations.location_id
    RIGHT OUTER JOIN countries ON locations.country_id = countries.country_id;
--
--11.	Selecione todos países que não possuem departamentos.

SELECT
    country_name
FROM
    departments
    INNER JOIN locations ON departments.location_id = locations.location_id
    RIGHT OUTER JOIN countries ON locations.country_id = countries.country_id
WHERE
    department_name IS NULL;
--
--12.	Selecione no histórico de funções (job_history), o nome e sobrenome do funcionário, o título da função e o nome do departamento, incluindo os funcionários que não possuem histórico.

SELECT
    first_name,
    last_name,
    job_title,
    department_name
FROM
    job_history
    RIGHT OUTER JOIN employees ON job_history.employee_id = employees.employee_id
    INNER JOIN jobs ON job_history.job_id = jobs.job_id
    INNER JOIN departments ON job_history.department_id = departments.department_id;


--
--13.	Selecione no histórico de funções (job_history), o nome e sobrenome do funcionário, o título da função e o nome do departamento, incluindo os funcionários e as funções que não possuem histórico.
--

SELECT
    first_name,
    last_name,
    job_title,
    department_name
FROM
    job_history
    RIGHT OUTER JOIN employees ON job_history.employee_id = employees.employee_id
    RIGHT OUTER JOIN jobs ON job_history.job_id = jobs.job_id
    INNER JOIN departments ON job_history.department_id = departments.department_id;
--14.	Selecione no histórico de funções (job_history), o nome e sobrenome do funcionário, o título da função e o nome do departamento, incluindo os funcionários, as funções e os departamentos que não possuem histórico.
--

SELECT
    first_name,
    last_name,
    job_title,
    department_name
FROM
    job_history
    RIGHT OUTER JOIN employees ON job_history.employee_id = employees.employee_id
    RIGHT OUTER JOIN jobs ON job_history.job_id = jobs.job_id
    RIGHT OUTER JOIN departments ON job_history.department_id = departments.department_id;