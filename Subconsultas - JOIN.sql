-- Exercício 1 -- Utilize sub-consultas (consultas aninhadas) para recuperar os dados dos empregados que trabalham no mesmo departamento que o empregado cujo e-mail é BERNST. A consulta não deve mostrar os dados do empregado do email BERNST.
SELECT
    *
FROM
    employees
WHERE
    department_id IN (
        SELECT
            department_id
        FROM
            employees
        WHERE
            email = 'BERNST'
    )
    AND email != 'BERNST';

-- Exercício 2 -- Resolva o exercício 1 sem usar sub-consultas. Use auto-junções (self joins): join da tabela employees com ela mesma.

SELECT
    *
FROM
    employees a
    JOIN employees b ON a.department_id = b.department_id
                        AND b.email = 'BERNST'
                        AND a.email != 'BERNST';

-- Exercício 3 -- Escreva uma consulta para recuperar nome, departamento e job_id de todos os empregados que trabalhem nos departamentos que tenham location_id = 1700.

SELECT
    e.first_name
    || ' '
    || e.last_name nome,
    e.department_id,
    e.job_id
FROM
    employees e
    JOIN departments d ON d.department_id = e.department_id
WHERE
    d.location_id = 1700;

-- Exercício 4 -- Liste nome e salário dos empregados gerenciados por King. Use sub-consultas.

SELECT
    first_name
    || ' '
    || last_name nome,
    salary
FROM
    employees
WHERE
    manager_id IN (
        SELECT
            employee_id
        FROM
            employees
        WHERE
            upper(last_name) = 'KING'
    );

-- Exercício 5 -- Liste nome, salário e job_title dos empregados que trabalham no departamento ‘Executive’.

SELECT
    e.first_name
    || ' '
    || e.last_name nome,
    e.salary,
    j.job_title
FROM
    employees e
    JOIN jobs j ON j.job_id = e.job_id
    JOIN departments d ON d.department_id = e.department_id
                          AND upper(department_name) = 'EXECUTIVE';

-- Exercício 6 -- Liste código, nome e salário de todos os empregados que ganhem mais do que a média dos
-- salários pagos no Reino Unido (United Kingdom). Ordene os resultados em ordem decrescente de salário.

SELECT
    job_id,
    first_name
    || ' '
    || last_name nome,
    salary
FROM
    employees
WHERE
    salary > (
        SELECT
            AVG(salary)
        FROM
            employees
        WHERE
            department_id IN (
                SELECT
                    department_id
                FROM
                    departments
                WHERE
                    location_id IN (
                        SELECT
                            location_id
                        FROM
                            locations
                        WHERE
                            country_id IN (
                                SELECT
                                    country_id
                                FROM
                                    countries
                                WHERE
                                    upper(country_name) = 'UNITED KINGDOM'
                            )
                    )
            )
    );

SELECT
    job_id,
    first_name
    || ' '
    || last_name nome,
    salary
FROM
    employees
WHERE
    salary > (
        SELECT
            AVG(salary)
        FROM
            employees
            INNER JOIN departments USING ( department_id )
            INNER JOIN locations USING ( location_id )
            INNER JOIN countries USING ( country_id )
        WHERE
            upper(country_name) = 'UNITED KINGDOM'
    );

-- Exercício 7 -- Modifique a consulta do exercício anterior para listar apenas dados dos empregados do Canadá que ganhem mais do que a média dos salários pagos no Reino Unido (United Kingdom).

SELECT
    job_id,
    first_name
    || ' '
    || last_name nome,
    salary
FROM
    employees
WHERE
    salary > (
        SELECT
            AVG(salary)
        FROM
            employees
        WHERE
            department_id IN (
                SELECT
                    department_id
                FROM
                    departments
                WHERE
                    location_id IN (
                        SELECT
                            location_id
                        FROM
                            locations
                        WHERE
                            country_id IN (
                                SELECT
                                    country_id
                                FROM
                                    countries
                                WHERE
                                    upper(country_name) = 'UNITED KINGDOM'
                            )
                    )
            )
    )
    AND department_id IN (
        SELECT
            department_id
        FROM
            departments
        WHERE
            location_id IN (
                SELECT
                    location_id
                FROM
                    locations
                WHERE
                    country_id IN (
                        SELECT
                            country_id
                        FROM
                            countries
                        WHERE
                            upper(country_name) = 'CANADA'
                    )
            )
    );

SELECT
    job_id,
    first_name
    || ' '
    || last_name nome,
    salary
FROM
    employees
    INNER JOIN departments USING ( department_id )
    INNER JOIN locations USING ( location_id )
    INNER JOIN countries USING ( country_id )
WHERE
    upper(country_name) = 'CANADA'
    AND salary > (
        SELECT
            AVG(salary)
        FROM
            employees
            INNER JOIN departments USING ( department_id )
            INNER JOIN locations USING ( location_id )
            INNER JOIN countries USING ( country_id )
        WHERE
            upper(country_name) = 'UNITED KINGDOM'
    );

-- Exercício 8 -- Recupere nome, salário, nome do departamento e título da função dos empregados cujos salários sejam iguais ao menor salário pago em toda a empresa.

SELECT
    a.first_name,
    a.salary,
    d.department_name,
    j.job_title
FROM
    employees a
    JOIN departments d ON d.department_id = a.department_id
    JOIN jobs j ON j.job_id = a.job_id
                   AND a.salary IN (
        SELECT
            MIN(salary)
        FROM
            employees
    );

-- Exercício 9 -- Recupere nome, sobrenome e título da função dos empregados gerenciados por 'Greenberg'.

SELECT
    a.first_name,
    a.last_name,
    j.job_title
FROM
    employees a
    JOIN jobs j ON j.job_id = a.job_id
    JOIN employees b ON a.manager_id = b.employee_id
                        AND lower(b.last_name) = 'greenberg';

-- Exercício 10 -- Recupere nome, sobrenome, titulo da função, nome do departamento, nome da cidade do
-- departamento e e-mail do gerente dos empregados cujo id seja 134, 159 ou 183. 11)

SELECT
    a.first_name,
    a.last_name,
    j.job_title,
    d.department_name,
    l.city,
    b.email
FROM
    employees a
    JOIN jobs j ON j.job_id = a.job_id
    JOIN departments d ON a.department_id = d.department_id
    JOIN locations l ON d.location_id = l.location_id
    JOIN employees b ON a.manager_id = b.employee_id
                        AND a.employee_id IN (
        134,
        159,
        183
    );

-- Exercício 11 A -- Recupere nome, sobrenome, titulo da função e nome do departamento dos empregados cujos
-- salários estejam na faixa de 1000 a 3000. Escreva três versões para essa consulta:
-- a. Sem sub-consulta com operador between;
-- b. Com sub-consulta com o operador IN;
-- c. Com sub-consulta com o operador EXISTS.

SELECT
    a.first_name,
    a.last_name,
    j.job_title,
    d.department_name
FROM
    employees a
    JOIN jobs j ON j.job_id = a.job_id
    JOIN departments d ON a.department_id = d.department_id
                          AND a.salary BETWEEN 1000 AND 3000;

-- Exercício 11 B --

SELECT
    a.first_name,
    a.last_name,
    j.job_title,
    d.department_name,
    a.salary
FROM
    employees a
    JOIN jobs j ON j.job_id = a.job_id
    JOIN departments d ON a.department_id = d.department_id
                          AND a.salary IN (
        SELECT
            salary
        FROM
            employees
        WHERE
            salary >= 1000
            AND salary <= 3000
    );

-- Exercício 11 C --

SELECT
    a.first_name,
    a.last_name,
    j.job_title,
    d.department_name,
    a.salary
FROM
    employees a
    JOIN jobs j ON j.job_id = a.job_id
    JOIN departments d ON a.department_id = d.department_id
                          AND EXISTS (
        SELECT
            *
        FROM
            employees b
        WHERE
            salary >= 1000
            AND salary <= 3000
            AND a.salary = b.salary
    );

-- Exercício 12 -- Recupere nome, sobrenome e título da função dos empregados que não sejam gerentes e cujo
-- departamento esteja localizado em Toronto.

SELECT
    e1.first_name,
    e1.last_name,
    job_title
FROM
    employees e1
    INNER JOIN jobs USING ( job_id )
    INNER JOIN departments USING ( department_id )
    INNER JOIN locations USING ( location_id )
WHERE
    upper(city) = 'TORONTO'
    AND employee_id NOT IN (
        SELECT DISTINCT
            m.employee_id
        FROM
            employees e
            INNER JOIN employees m ON e.manager_id = m.employee_id
    );

-- Exercício 13 -- Recupere nome, sobrenome e título da função dos empregados cujo salário seja menor do que
-- qualquer salário pago a funcionários com job_id igual a 'MK_MAN'.

SELECT
    first_name,
    last_name,
    job_title
FROM
    employees
    INNER JOIN jobs USING ( job_id )
WHERE
    salary < ANY (
        SELECT
            salary
        FROM
            employees
        WHERE
            upper(job_id) = 'MK_MAN'
    );

-- Exercício 14 -- Repita a consulta do exercício anterior, excluindo empregados com job_id igual a 'MK_MAN'.

SELECT
    first_name,
    last_name,
    job_title
FROM
    employees
    INNER JOIN jobs USING ( job_id )
WHERE
    upper(job_id) != 'MK_MAN'
    AND salary < ANY (
        SELECT
            salary
        FROM
            employees
        WHERE
            upper(job_id) = 'MK_MAN'
    );

-- Exercício 15 -- Recupere nome e departamento dos empregados que trabalhem em um departamento em que
-- exista um salário maior do que 4500.

SELECT
    first_name,
    department_name
FROM
    employees
    INNER JOIN departments USING ( department_id )
WHERE
    department_id IN (
        SELECT DISTINCT
            department_id
        FROM
            employees
        WHERE
            salary > 4500
    );

SELECT
    a.first_name,
    d.department_name
FROM
    employees a
    JOIN departments d ON d.department_id = a.department_id
                          AND EXISTS (
        SELECT
            *
        FROM
            employees b
        WHERE
            d.department_id = b.department_id
            AND b.salary > 4500
    );

-- Exercício 16 -- Recupere os departamentos que tenham pelo menos um empregado.

SELECT DISTINCT
    department_name
FROM
    employees
    INNER JOIN departments USING ( department_id );

-- Exercício 17 -- Recupere dados dos empregados que trabalham na região Americas.

SELECT
    e.*
FROM
    employees e
    JOIN departments d ON e.department_id = d.department_id
    JOIN locations l ON d.location_id = l.location_id
    JOIN countries c ON l.country_id = c.country_id
    JOIN regions r ON c.region_id = r.region_id
WHERE
    lower(r.region_name) = 'americas';

-- Exercício 18 -- Recupere dados dos empregados que gerenciem algum departamento.

SELECT
    e.first_name,
    e.last_name,
    d.department_name
FROM
    departments d
    JOIN employees e ON d.manager_id = e.employee_id;

-- Exercício 19 -- Recupere dados dos empregados que recebam salário igual ao maior salário pago às pessoas
-- contratadas entre 01/01/2002 e 31/12/2003.

SELECT
    *
FROM
    employees
WHERE
    salary IN (
        SELECT
            MAX(salary)
        FROM
            employees
        WHERE
            hire_date BETWEEN TO_DATE('01/01/2002', 'dd/mm/yyyy') AND TO_DATE('31/12/2003', 'dd/mm/yyyy')
    );

SELECT
    *
FROM
    employees
WHERE
    salary IN (
        SELECT
            MAX(salary)
        FROM
            employees
        WHERE
            hire_date >= '01/01/02'
            AND hire_date <= '31/12/03'
    );

SELECT
    SYSDATE
FROM
    dual;

-- Exercício 20 -- Recupere nome do país e região do globo em que está localizado.

SELECT
    c.country_name,
    r.region_name
FROM
    countries c
    JOIN regions r ON c.region_id = r.region_id;



-- Exercício 21 -- Para cada departamento, liste seu nome, país e região do globo em que está localizado.

SELECT
    d.department_name,
    c.country_name,
    r.region_name
FROM
    departments d
    JOIN locations l ON d.location_id = l.location_id
    JOIN countries c ON l.country_id = c.country_id
    JOIN regions r ON c.region_id = r.region_id;

-- Exercício 22 -- Qual é o número de empregados por departamento? Mostre o nome do departamento e o
-- respectivo número de empregados.

SELECT
    d.department_name,
    COUNT(e.employee_id) "Número de Funcionários"
FROM
    employees e
    JOIN departments d ON e.department_id = d.department_id
GROUP BY
    d.department_name
ORDER BY
    d.department_name;


-- Exercício 23 -- Repita o exercício anterior, mostrando apenas os departamentos com mais de 2 empregados,
-- em ordem crescente por número de empregados.

SELECT
    d.department_name,
    COUNT(e.employee_id) "Número de Funcionários"
FROM
    employees e
    JOIN departments d ON e.department_id = d.department_id
GROUP BY
    d.department_name
HAVING
    COUNT(e.employee_id) > 2
ORDER BY
    COUNT(e.employee_id) ASC;

-- Exercício 24 -- Qual é a região do globo em que está localizado o maior número de departamentos? Mostre o
-- resultado em apenas uma linha, contendo duas colunas: nome_regiao e num_deptos.

SELECT
    *
FROM
    (
        SELECT
            r.region_name   "REGIÃO",
            COUNT(d.department_id) "DEPARTAMENTOS"
        FROM
            departments d
            JOIN locations l ON d.location_id = l.location_id
            JOIN countries c ON c.country_id = l.country_id
            JOIN regions r ON r.region_id = c.region_id
        GROUP BY
            r.region_name
        ORDER BY
            COUNT(d.department_id) DESC
    )
WHERE
    ROWNUM = 1;

-- Exercício 25 -- Qual é o número de departamentos por região do globo? Cada linha do resultado deve conter
-- duas colunas: nome_regiao e num_deptos.

SELECT
    COUNT(d.department_id) "NUM_DEPTOS",
    r.region_name
FROM
    departments d
    JOIN locations l ON d.location_id = l.location_id
    JOIN countries c ON l.country_id = c.country_id
    JOIN regions r ON c.region_id = r.region_id
GROUP BY
    r.region_name;

-- Exercício 26 -- Qual é o número de departamentos por região do globo? Cada linha do resultado deve conter
-- duas colunas: nome_regiao e num_deptos. Mostre também as regiões que tem zero departamentos.

SELECT
    r.region_name,
    COUNT(d.department_name)
FROM
    departments d
    JOIN locations l ON d.location_id = l.location_id
    JOIN countries c ON l.country_id = c.country_id
    RIGHT OUTER JOIN regions r ON c.region_id = r.region_id
GROUP BY
    r.region_name;

-- Exercício 27 -- Qual é o número de empregados por região do globo? Mostre também as regiões que tenham zero empregados. Verifique se o número de empregados retornados pela sua consulta coincide
-- com o total de empregados existentes na tabela EMPLOYEES. 

SELECT
    r.region_name,
    COUNT(e.employee_id)
FROM
    employees e
    JOIN departments d ON e.department_id = d.department_id
    JOIN locations l ON d.location_id = l.location_id
    JOIN countries c ON l.country_id = c.country_id
    RIGHT OUTER JOIN regions r ON c.region_id = r.region_id
GROUP BY
    r.region_name;

-- Exercício 28 -- Quantos empregados desempenhando cada função (job_id) existem em cada região do globo?
-- Para cada linha, mostre três colunas: regiao, função e num_empregados. Mostre apenas as
-- regiões em que há pelo menos um empregado. Ordene os resultados por região e por função.

SELECT
    r.region_name,
    e.job_id,
    COUNT(e.employee_id)
FROM
    employees e
    JOIN departments d ON d.department_id = e.department_id
    JOIN locations l ON d.location_id = l.location_id
    JOIN countries c ON c.country_id = l.country_id
    JOIN regions r ON r.region_id = c.region_id
GROUP BY
    r.region_name,
    e.job_id
ORDER BY
    r.region_name,
    e.job_id;