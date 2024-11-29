/* 
COVID-19 Global Data Analysis
Using SQL techniques: Joins, CTE, Temp Tables, Window Functions, Aggregate Functions, Views, Data Type Conversion
*/

/* 1. Calculate Mortality Rate: Total Deaths / Total Cases */
SELECT continent, location, date, total_cases, total_deaths, 
       (CAST(total_deaths AS FLOAT) / total_cases) * 100 AS mortality_rate
FROM coviddeaths
WHERE continent IS NOT NULL
ORDER BY continent, location;

/* 2. Calculate Percentage of Population Infected */
SELECT continent, location, date, total_cases, population, 
       (CAST(total_cases AS FLOAT) / population) * 100 AS percent_population_infected
FROM coviddeaths
WHERE continent IS NOT NULL
ORDER BY continent, location;

/* 3. Find Country with Highest Infection Rate (Cases per Population) */
SELECT continent, location, population, 
       MAX(total_cases) AS highest_infection_count,
       MAX((CAST(total_cases AS FLOAT) / population) * 100) AS infection_rate_percentage
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY continent, location, population
ORDER BY highest_infection_count DESC;

/* 4. Identify Country with Highest Death Rate per Population */
SELECT continent, location, population, 
       MAX(total_deaths) AS highest_death_count,
       MAX((CAST(total_deaths AS FLOAT) / population) * 100) AS death_rate_percentage
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY continent, location, population
ORDER BY highest_death_count DESC;

/* 5. Identify Country with Maximum Death Count */
SELECT continent, location, MAX(total_deaths) AS highest_death_count
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY continent, location
ORDER BY highest_death_count DESC;

/* 6. Identify Continent with Maximum Death Count */
SELECT continent, MAX(total_deaths) AS highest_death_count
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY highest_death_count DESC;

/* 7. Daily Global Cases Summary */
SELECT date, 
       SUM(new_cases) AS total_new_cases, 
       SUM(new_deaths) AS total_new_deaths,
       CASE
           WHEN SUM(new_cases) <> 0 THEN (SUM(new_deaths) * 100.0 / SUM(new_cases))
           ELSE NULL
       END AS death_rate_percentage
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date;

/* 8. Rolling Vaccination Count using CTE */
WITH VaccinationData AS (
    SELECT dea.continent, dea.location, dea.date, dea.population, 
           vac.new_vaccinations, 
           SUM(CAST(vac.new_vaccinations AS BIGINT)) 
               OVER (PARTITION BY dea.location ORDER BY dea.date) AS rolling_vaccination_count
    FROM coviddeaths dea
    JOIN covidvaccinations vac 
        ON dea.location = vac.location AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
)
SELECT continent, location, date, population, new_vaccinations, rolling_vaccination_count, 
       (CAST(rolling_vaccination_count AS FLOAT) / population) * 100 AS vaccination_percentage
FROM VaccinationData;

/* 9. Rolling Vaccination Count using Temp Table */
DROP TABLE IF EXISTS #VaccinationStats;
CREATE TABLE #VaccinationStats (
    continent NVARCHAR(255),
    location NVARCHAR(255),
    date DATE,
    population NUMERIC,
    new_vaccinations NUMERIC,
    rolling_vaccination_count NUMERIC
);

INSERT INTO #VaccinationStats
SELECT dea.continent, dea.location, dea.date, dea.population, 
       vac.new_vaccinations, 
       SUM(CAST(vac.new_vaccinations AS BIGINT)) 
           OVER (PARTITION BY dea.location ORDER BY dea.date) AS rolling_vaccination_count
FROM coviddeaths dea
JOIN covidvaccinations vac 
    ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;

SELECT continent, location, date, population, new_vaccinations, rolling_vaccination_count, 
       (CAST(rolling_vaccination_count AS FLOAT) / population) * 100 AS vaccination_percentage
FROM #VaccinationStats
ORDER BY location, date;

/* 10. Create Views for Future Use */
CREATE VIEW mortality_rate_view AS
SELECT continent, location, date, total_cases, total_deaths, 
       (CAST(total_deaths AS FLOAT) / total_cases) * 100 AS mortality_rate
FROM coviddeaths
WHERE continent IS NOT NULL;

CREATE VIEW percent_population_infected_view AS
SELECT continent, location, date, total_cases, population, 
       (CAST(total_cases AS FLOAT) / population) * 100 AS percent_population_infected
FROM coviddeaths
WHERE continent IS NOT NULL;

CREATE VIEW highest_infected_country_view AS
SELECT continent, location, population, 
       MAX(total_cases) AS highest_infection_count,
       MAX((CAST(total_cases AS FLOAT) / population) * 100) AS infection_rate_percentage
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY continent, location, population;

CREATE VIEW highest_death_rate_per_population_view AS
SELECT continent, location, population, 
       MAX(total_deaths) AS highest_death_count,
       MAX((CAST(total_deaths AS FLOAT) / population) * 100) AS death_rate_percentage
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY continent, location, population;

CREATE VIEW global_cases_per_day_view AS
SELECT date, 
       SUM(new_cases) AS total_new_cases, 
       SUM(new_deaths) AS total_new_deaths,
       CASE
           WHEN SUM(new_cases) <> 0 THEN (SUM(new_deaths) * 100.0 / SUM(new_cases))
           ELSE NULL
       END AS death_rate_percentage
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY date;

CREATE VIEW rolling_vaccination_count_view AS
WITH VaccinationData AS (
    SELECT dea.continent, dea.location, dea.date, dea.population, 
           vac.new_vaccinations, 
           SUM(CAST(vac.new_vaccinations AS BIGINT)) 
               OVER (PARTITION BY dea.location ORDER BY dea.date) AS rolling_vaccination_count
    FROM coviddeaths dea
    JOIN covidvaccinations vac 
        ON dea.location = vac.location AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
)
SELECT continent, location, date, population, new_vaccinations, rolling_vaccination_count, 
       (CAST(rolling_vaccination_count AS FLOAT) / population) * 100 AS vaccination_percentage
FROM VaccinationData;
