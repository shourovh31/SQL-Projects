use PortfolioProject;


select * from CovidDeaths;

select * from CovidVaccination;

select location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths
order by 1,2;

--Total Cases Vs Total Deaths

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths
where location like '%kingdom%'
order by 1,2;


--Total Cases vs Population
select location, population, max(total_cases) as highestInfectionCount ,max((total_cases/population))*100 as InfectionRatio
from CovidDeaths
--where location like '%kingdom%'
group by location,population
order by infectionRatio desc;



--showing countries with highest death counts compare with population

select location, population, max(total_deaths) as TotalDeaths ,max((total_deaths/population))*100 as DeathPercentage
from CovidDeaths
--where location like '%kingdom%'
group by location,population
order by DeathPercentage desc;
----

--Total deaths by locations

select location, max(cast(total_deaths as int)) as TotalDeaths
from CovidDeaths
--where location like '%kingdom%'
where continent is not null
group by location
order by TotalDeaths desc;



--Analysis by based on Continent
--Showing the continet with the highest DeathCount

select location, max(cast(total_deaths as int)) as TotalDeathsCount
from CovidDeaths
where continent is null
group by location
order by TotalDeathsCount desc;

--below is incorrect

select continent, max(cast(total_deaths as int)) as TotalDeathsCount
from CovidDeaths
where continent is not null
group by continent
order by TotalDeathsCount desc;



--Global Levels


select 
	date, 
	sum(new_cases)as TotalCases,
	sum(cast(new_deaths as int)) TotalNwDeaths,
	sum(cast(new_deaths as int))/sum(new_cases)* 100 as DeathPercentage
from CovidDeaths
where continent is not null
and total_cases is not null
group by date
order by 1,2;



--AllTotalAcrossTheWorld

select  
	sum(new_cases)as TotalCases,
	sum(cast(new_deaths as int)) TotalNwDeaths,
	sum(cast(new_deaths as int))/sum(new_cases)* 100 as DeathPercentage
from CovidDeaths
where continent is not null
and total_cases is not null
--group by date
order by 1,2;

--Finding Vaccination to Population

select 
	deaths.continent, 
	deaths.location, 
	deaths.date, 
	deaths.population, 
	vac.new_vaccinations,
	sum(convert(int, vac.new_vaccinations)) over (partition by deaths.location order by deaths.location, deaths.date) as CumulativeVaccinations
from CovidDeaths deaths
	Join CovidVaccination vac
	on deaths.location = vac.location
	and deaths.date = vac.date
	where deaths.continent is not null
	and deaths.population is not null
	and vac.new_vaccinations is not null
order by 2,3;


--if we want to find the vaccionation rate over population now we have to create a cte or views. Because we cant just devide a column we jsust created here



--HERE I AM USING CTE

With POPVSVAC (Continent, location,Date, population, new_vaccinations, CumulativeVaccinations)
AS
(
select 
	deaths.continent, 
	deaths.location, 
	deaths.date, 
	deaths.population, 
	vac.new_vaccinations,
	sum(convert(int, vac.new_vaccinations)) over (partition by deaths.location order by deaths.location, deaths.date) as CumulativeVaccinations
from CovidDeaths deaths
	Join CovidVaccination vac
	on deaths.location = vac.location
	and deaths.date = vac.date
	where deaths.continent is not null
	and deaths.population is not null
	and vac.new_vaccinations is not null
)
Select * ,
(CumulativeVaccinations/population)*100 as VaccinationRatioToPeople
from POPVSVAC;




---TEMP TABLE
Drop Table if exists #PercentPeopleVaccinated;
Create Table #PercentPeopleVaccinated
(
continent nvarchar(250),
Location nvarchar(250),
Date datetime,
Population numeric,
New_Vaccinations numeric,
CumulativeVaccinations numeric
--VaccinationRatioToPeople numeric
)

insert into #PercentPeopleVaccinated
select 
	deaths.continent, 
	deaths.location, 
	deaths.date, 
	deaths.population, 
	vac.new_vaccinations,
	sum(convert(int, vac.new_vaccinations)) over (partition by deaths.location order by deaths.location, deaths.date) as CumulativeVaccinations
from CovidDeaths deaths
	Join CovidVaccination vac
	on deaths.location = vac.location
	and deaths.date = vac.date
	where deaths.continent is not null
	and deaths.population is not null
	and vac.new_vaccinations is not null

Select * ,
(CumulativeVaccinations/population)*100 as VaccinationRatioToPeople
from #PercentPeopleVaccinated


--Creating View for Data Visualisations later

Create View PercentPopulationVaccinated as
select 
	deaths.continent, 
	deaths.location, 
	deaths.date, 
	deaths.population, 
	vac.new_vaccinations,
	sum(convert(int, vac.new_vaccinations)) over (partition by deaths.location order by deaths.location, deaths.date) as CumulativeVaccinations
from CovidDeaths deaths
	Join CovidVaccination vac
	on deaths.location = vac.location
	and deaths.date = vac.date
	where deaths.continent is not null
	and deaths.population is not null
	and vac.new_vaccinations is not null


	select * from PercentPopulationVaccinated
