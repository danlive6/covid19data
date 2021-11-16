 

select location, date, total_cases, new_cases, total_deaths,population
from portfolioproject..CovidDeath
where continent is not null
order by 1,2

select *

from portfolioproject..covidvaccination

--looking at total cases vs total deaths
--this shows the likelihood of dying if you contract covid in your country

select location, date, total_cases,total_deaths,(total_deaths/total_cases)*100 as Deathpercentage

From portfolioproject..CovidDeath
where location like '%nigeria%'
and continent is not null
order by 1,2

--looking at total cases vs population
--shows what percentage of population has got covid

select location, date,population, total_cases,(total_cases/population)*100 as PopulationPercentage
From portfolioproject..CovidDeath
where location like '%nigeria%'
and continent is not null
order by 1,2

--looking at the countries with highest infection rates vs population

select location,population, max(total_cases)as HighestinfectionCount,max((total_cases/population))*100 as 
PercentagePopulationInfected
From portfolioproject..CovidDeath
--where location like '%nigeria%'
group by location,population
order by PercentagePopulationInfected desc


--looking at the Highest Death count per population.

select location,max(cast(total_deaths as int)) as totaldeathcount
From portfolioproject..CovidDeath
--where location like '%nigeria%'
where continent is not null
group by location
order by totaldeathcount desc

--lets break things down by continent

select continent ,max(cast(total_deaths as int)) as totaldeathcount
From portfolioproject..CovidDeath
--where location like '%nigeria%'
where continent is  not null
group by continent
order by totaldeathcount desc

--Global Numbers

select sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as Deathpercentage

From portfolioproject..CovidDeath
--where location like '%nigeria%'
where continent is not null
--group by date
order by 1,2

--looking at total population vs vaccinations.
select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint))over (partition by dea.location order by dea.location,dea.date ) 
as Rollingpeoplevaccinated
from portfolioproject..CovidDeath dea
join portfolioproject..CovidVaccination vac
on dea.location = vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3

--use CTE
with popvsvac (continent,location,date,population,new_vaccinations,rollingpeoplevaccinated)
as
(
select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint))over (partition by dea.location order by dea.location,dea.date ) as Rollingpeoplevaccinated
from portfolioproject..CovidDeath dea
join portfolioproject..CovidVaccination vac
on dea.location = vac.location
and dea.date=vac.date
where dea.continent is not null)
--order by 2,3
select * ,( rollingpeoplevaccinated/population)*100
from popvsvac

--Temp Table
create Table PercentPopulationvaccinated
(
continent nvarchar(255),
location nvarchar (255),
date datetime,
population numeric,
new_vaccinations numeric,
Rollingpeoplevaccinated numeric
)
insert into PercentPopulationvaccinated
select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint))over (partition by dea.location order by dea.location,dea.date ) as Rollingpeoplevaccinated
from portfolioproject..CovidDeath dea
join portfolioproject..CovidVaccination vac
on dea.location = vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3

select * ,( rollingpeoplevaccinated/population)*100
from PercentPopulationvaccinated

--Creating view to store data for later Visualisation
create view PercentaPopulationvaccinated as
select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint))over (partition by dea.location order by dea.location,dea.date ) as Rollingpeoplevaccinated
from portfolioproject..CovidDeath dea
join portfolioproject..CovidVaccination vac
on dea.location = vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3

select * from PercentaPopulationvaccinated







