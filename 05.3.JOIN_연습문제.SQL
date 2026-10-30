-- 1. 모든 사원의 사번, 사원명, 부서명을 조회하시오.
--    부서가 배정되지 않은 사원도 포함하고, 사번 오름차순으로 정렬하시오.
select EMP_ID, EMP_NAME, DEPT_TITLE
from EMPLOYEE
left join DEPARTMENT on (DEPT_ID = DEPT_CODE)
order by 1;

-- 2. 모든 사원의 사원명, 직급명을 조회하시오.
--    직급명이 '대리'인 사원만 조회하고 사원명 오름차순으로 정렬하시오.
select EMP_NAME, JOB_NAME
from EMPLOYEE
join JOB USING(JOB_CODE)
where JOB_NAME='대리'
order by EMP_NAME;
-- 3. 부서가 배정된 사원의 사원명, 부서명, 급여를 조회하시오.
--    급여가 3000000 이상인 사원만 급여 내림차순으로 정렬하시오.
select EMP_NAME, DEPT_TITLE, SALARY
from EMPLOYEE
join DEPARTMENT on (DEPT_CODE = DEPT_ID)
where SALARY >=3000000
order by SALARY desc;
-- 4. 모든 부서의 부서명과 소속 사원 수를 조회하시오.
--    사원이 한 명도 없는 부서도 0명으로 출력하고, 부서코드 오름차순으로 정렬하시오.
select DEPT_TITLE, COUNT(DEPT_CODE)
from EMPLOYEE
right join DEPARTMENT on (DEPT_CODE = DEPT_ID)
group by DEPT_ID
order by DEPT_ID;
-- 5. 사원명, 부서명, 직급명을 조회하시오.
--    부서가 배정되지 않은 사원도 포함하고 사번 오름차순으로 정렬하시오.
select EMP_NAME, DEPT_TITLE, JOB_NAME
from EMPLOYEE
left join DEPARTMENT on (DEPT_ID = DEPT_CODE)
join JOB using(JOB_CODE)
order by EMP_ID;
-- 6. 부서가 배정된 사원의 사원명, 부서명, 근무 지역명, 국가명을 조회하시오.
--    사번 오름차순으로 정렬하시오.
select EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
from EMPLOYEE
join DEPARTMENT on (DEPT_CODE = DEPT_ID)
join location on (location_ID = LOCAL_CODE)
join national USING(NATIONAL_CODE)
order by EMP_ID;
-- 7. 관리자 사번이 등록된 사원의 사원명과 관리자명을 조회하시오.
--    해당 관리자 사번을 가진 사원이 EMPLOYEE 테이블에 실제로 존재하는 경우만 출력하시오.
select E.EMP_NAME, M.EMP_NAME 
from EMPLOYEE E
join EMPLOYEE M on (E.MANAGER_ID = M.EMP_ID)
where E.manager_id = M.EMP_ID;

-- 8. 모든 사원의 사원명, 급여, 급여등급을 조회하시오.
--    급여등급은 급여가 최소급여와 최대급여 사이에 있는 경우 매칭하고, 사번 오름차순으로 정렬하시오.
select EMP_NAME, SALARY, SAL_LEVEL
from EMPLOYEE
join SAL_GRADE on (SALARY between MIN_SAL and MAX_SAL)
order by EMP_ID;

-- 9. 부서별 부서명, 평균급여를 조회하시오.
--    소속 사원이 2명 이상인 부서만 조회하고 평균급여 내림차순으로 정렬하시오.
select DEPT_TITLE, ROUND(AVG(SALARY),-1) as 평균급여
from EMPLOYEE
join DEPARTMENT on (DEPT_ID = DEPT_CODE)
group by DEPT_TITLE
having count(*) >= 2
order by 평균급여 desc;

-- 10. 모든 국가의 국가명과 해당 국가에 위치한 부서의 소속 사원 수를 조회하시오.
--     소속 사원이 없는 국가도 0명으로 출력하고, 사원 수 내림차순, 국가명 오름차순으로 정렬하시오.
select NATIONAL_NAME, COUNT(EMP_NAME) as "사원 수" 
from EMPLOYEE
right join DEPARTMENT on (DEPT_ID = DEPT_CODE)
right join location on (LOCAL_CODE = location_ID)
right join national using(NATIONAL_CODE)
group by national_NAME
order by "사원 수" desc, national_NAME;

