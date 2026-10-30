-- 1. EMPLOYEE 테이블에서 부서코드(DEPT_CODE)별 평균 급여를 구하시오. (단, 부서코드가 NULL인 사원은 제외)
select DEPT_CODE, ROUND(AVG(SALARY),-1)
from EMPLOYEE
group by DEPT_CODE
having DEPT_CODE is not NULL;
-- 2. EMPLOYEE 테이블에서 직급코드(JOB_CODE)별 보너스를 받는 사원 수를 구하시오. 단, 보너스를 받는 사원이 2명 이상인 직급만 조회하시오.
select JOB_CODE, COUNT(BONUS)
from EMPLOYEE
group by JOB_CODE
having COUNT(BONUS) >= 2;
-- 3. EMPLOYEE 테이블에서 부서코드(DEPT_CODE)별 평균 급여가 3,000,000원 이상인 부서의 부서코드와 평균 급여를 조회하시오.
select DEPT_CODE, ROUND(AVG(SALARY),-1)
from EMPLOYEE
group by DEPT_CODE
having AVG(SALARY) >= 3000000;
-- 4. EMPLOYEE 테이블에서 부서코드(DEPT_CODE)와 직급코드(JOB_CODE)별 사원 수와, 부서별 소계 및 전체 총계를 함께 조회하시오. 
select DEPT_CODE, JOB_CODE, COUNT(*)
from EMPLOYEE
group by ROLLUP(DEPT_CODE, JOB_CODE)
order by DEPT_CODE, JOB_CODE;
-- 5. EMPLOYEE 테이블에서 부서코드(DEPT_CODE)와 직급코드(JOB_CODE)별 평균 급여를 구하되, 부서별 소계, 직급별 소계, 전체 총계가 모두 출력되도록 작성하시오.
select DEPT_CODE, JOB_CODE, ROUND(AVG(SALARY),-1)
from EMPLOYEE
group by CUBE(DEPT_CODE, JOB_CODE)
order by DEPT_CODE, JOB_CODE;
-- 6. EMPLOYEE 테이블에서 부서코드가 'D5'인 사원 또는 직급코드가 'J7'인 사원들의 이름, 부서코드, 급여를 중복 없이 조회하시오.
select EMP_NAME, DEPT_CODE, SALARY
from EMPLOYEE
where DEPT_CODE = 'D5' or JOB_CODE = 'J7';
-- 7. EMPLOYEE 테이블에서 급여가 3,000,000원 이상이면서 입사일(HIRE_DATE)이 2010년 1월 1일 이후인 사원의 사번,이름, 급여를 조회하시오
select EMP_ID, EMP_NAME, SALARY
from EMPLOYEE
where SALARY >= 3000000 and HIRE_DATE > '2010-01-01';
-- 8. EMPLOYEE 테이블에서 전체 사원의 사번, 이름, 부서코드를 조회하되, 부서코드가 'D5'인 사원들은 제외하고 조회하시오.
select EMP_ID, EMP_NAME, DEPT_CODE
from EMPLOYEE
except
select EMP_ID, EMP_NAME, DEPT_CODE
from employee
where DEPT_CODE = 'D5';