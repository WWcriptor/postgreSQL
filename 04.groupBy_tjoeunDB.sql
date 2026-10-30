/*
   <GROUP BY절>
   그룹기준을 제시할 수 있는 구문(그룹기준별로 여러 그룹으로 묶을 수 있음)
   여럭 값들을 하나의 그룹으로 묶어서 처리할 목적으로 사용
 */

select SUM(SALARY)
from EMPLOYEE;

-- 각 부서별 총 급여의 합
select DEPT_CODE, SUM(SALARY)
from EMPLOYEE
group by DEPT_CODE;

-- 각 부서별 사원 수
select DEPT_CODE, COUNT(*)
from EMPLOYEE
group by DEPT_CODE;

select DEPT_CODE, COUNT(*), SUM(SALARY)
from EMPLOYEE
group by DEPT_CODE
order by DEPT_CODE;

-- 직급별 인원수와 급여의 합계
select JOB_CODE, COUNT(*), SUM(SALARY)
from EMPLOYEE
group by JOB_CODE;

-- 직급별 총 사원수, 보너스를 받는 사원수, 급여 합, 급여 평균, 최저급여, 최고급여
select JOB_CODE, COUNT(*) as 총사원수, COUNT(BONUS) as "보너스를 받는 사원 수"
			   , SUM(SALARY) as 총급여, ROUND(AVG(SALARY),-1) as 급여평균
			   , MIN(SALARY) as 최저급여, MAX(SALARY) as 최고급여
from employee
group by JOB_CODE
order by JOB_CODE;
-- 남성, 여성별 사원수
select case when SUBSTR(EMP_NO, 8, 1) in ('1','3') then '남'
			when SUBSTR(EMP_NO, 8, 1) in ('2', '4') then '여'
	   end as 성별, COUNT(*) as 사원수
from EMPLOYEE
group by case when SUBSTR(EMP_NO, 8, 1) in ('1','3') then '남'
			  when SUBSTR(EMP_NO, 8, 1) in ('2', '4') then '여'
		 end;

select case when SUBSTR(EMP_NO, 8, 1) in ('1','3') then '남'
			when SUBSTR(EMP_NO, 8, 1) in ('2', '4') then '여'
	   end as 성별, COUNT(*) as 사원수
from EMPLOYEE
group by 성별;

-- GROUP BY 절에 여러 컬럼 기술 가능
select DEPT_CODE, JOB_CODE, COUNT(*), SUM(SALARY)
from EMPLOYEE
group by DEPT_CODE, JOB_CODE
order by DEPT_CODE;


--입사년도별 급여의 합계
select extract(year from HIRE_DATE) as 입사년도
	, COUNT(*) as 사원수
	, SUM(SALARY) as 급여합계
	, ROUND(AVG(SALARY),-1) as 급여평균
from EMPLOYEE
group by 입사년도
order by 1;

select TO_CHAR(HIRE_DATE, 'YYYY') as 입사년도
	, COUNT(*) as 사원수
	, SUM(SALARY) as 급여합계
	, ROUND(AVG(SALARY),-1) as 급여평균
from EMPLOYEE
group by 입사년도
order by 1;

------------------------------------------------------------
/*
   <HAVING 절>
   그룹에 대한 조건을 제시할 때 사용
 */

-- 각 부서별 급여 평균 조회
select DEPT_CODE, ROUND(AVG(SALARY),-1)
from EMPLOYEE
group by DEPT_CODE;

-- 각 부서별 평균 급여가 300만원 이상인 부서들만 조회
/*select DEPT_CODE, ROUND(AVG(SALARY), -1)
from EMPLOYEE
-- where AVG(SALARY)>= 3000000 그룹에 대한 조건은 WHERE절을 사용 x
group by DEPT_CODE;*/

select DEPT_CODE, ROUND(AVG(SALARY),-1)
from EMPLOYEE
group by DEPT_CODE
having AVG(SALARY) >= 3000000;

/*
   <실행 순서>
   FROM
   WHERE
   GROUP BY (SELECT에서 지정한 별칭을 사용할 수 있도록 예외로 둠)
   HAVING
   SELECT
   DISTINCT
   ORDER BY
 */

------------------------- 실습문제 ----------------
-- 1. 직급별 급여의 합(조건 : 직급별 급여의 합이 1000만원 이상인 직급만 조회), 직급코드와 급여의 합 출력
select JOB_CODE, SUM(SALARY)
from EMPLOYEE
group by JOB_CODE
having SUM(SALARY) >= 10000000;
-- 2. 부서별 보너스를 받는 사원이 없는 부서만 부서코드 조회
select DEPT_CODE, COUNT(BONUS)
from EMPLOYEE
group by DEPT_CODE
having COUNT(BONUS) = 0;

----------------------------------------------------------------
/*
   <집계함수>
   그룹별 산출된 결과 값에 중간 집계를 계산해주는 함수
   
   ROLLUP, CUBE
   => GROUP BY 절에 기술
   
   - ROLLUP(컬럼1, 컬럼2) : 컬럼1을 가지고 중간집계를 내는 함수
   - CUBE(컬럼1, 컬럼2) : 컬럼1을 가지고 중간집계 내고, 컬럼2를 가지고도 중간집계를 냄(행이 길어짐)
 */
-- 각 직급별 급여의 합
select JOB_CODE, SUM(SALARY)
from EMPLOYEE
group by JOB_CODE;

select JOB_CODE, SUM(SALARY)
from EMPLOYEE
group by ROLLUP(JOB_CODE); 
-- 그룹 기준이 하나의 컬럼일 때는 ROLLUP과 CUBE의 차이가 없음

select DEPT_CODE, JOB_CODE, SUM(SALARY)
from EMPLOYEE
group by DEPT_CODE, JOB_CODE;

-- ROLLUP(컬럼1, 컬럼2) : 컬럼1만 중간집계
select DEPT_CODE, JOB_CODE, SUM(SALARY)
from EMPLOYEE
group by rollup(DEPT_CODE, JOB_CODE)
order by DEPT_CODE, JOB_CODE;

-- CUBE(컬럽1, 컬럼2) : 컬럼1과 2 모두 중간집계
select DEPT_CODE, JOB_CODE, SUM(SALARY)
from EMPLOYEE
group by CUBE(DEPT_CODE, JOB_CODE)
order by DEPT_CODE, JOB_CODE;

-----------------------------------------------------------------------
/*
   <집합 연산자>
   여러개의 쿼리문을 가지고 하나의 쿼리문을 만드는 연산자
   
    - UNION : 합집합(OR)
    - INTERSECT : 교집합(AND)
    - UNION ALL : 합집합+교집합
    - EXCEPT : 차집합
 */

-- 1. UNION
-- 부서코드가 'D5'인 사원 또는 급여가 300만원 초과인 사원의 사번, 사원명, 부서코드, 급여 조회
-- 부서코드가 'D5'인 사원
select EMP_ID, EMP_NAME, DEPT_CODE, SALARY
from EMPLOYEE
where DEPT_CODE = 'D5';
-- 급여가 300만원 초과인 사원
select EMP_ID, EMP_NAME, DEPT_CODE, SALARY
from EMPLOYEE
where SALARY > 3000000;

select EMP_ID, EMP_NAME, DEPT_CODE, SALARY
from EMPLOYEE
where DEPT_CODE = 'D5'
union 
select EMP_ID, EMP_NAME, DEPT_CODE, SALARY
from EMPLOYEE
where SALARY > 3000000;

-- 2. INTERSECT
-- 부서코드가 'D5'이면서 급여가 300만원 초과인 사원들 조회
select EMP_ID, EMP_NAME, DEPT_CODE, SALARY
from EMPLOYEE
where DEPT_CODE = 'D5'
intersect 
select EMP_ID, EMP_NAME, DEPT_CODE, SALARY
from EMPLOYEE
where SALARY > 3000000;

-- 집합연산자 사용 시 유의사항
/*select EMP_ID, EMP_NAME, DEPT_CODE, SALARY
from EMPLOYEE
where DEPT_CODE = 'D5'
intersect 
select EMP_ID, EMP_NAME, DEPT_CODE
from EMPLOYEE
where SALARY > 3000000;*/ -- 오류 : 집합연산자를 사용하는 두 쿼리문은 같은 컬럼을 사용해야 함

select EMP_ID, EMP_NAME, DEPT_CODE, SALARY
from EMPLOYEE
where DEPT_CODE = 'D5'
intersect 
select EMP_ID, EMP_NAME, DEPT_CODE, BONUS
from EMPLOYEE
where SALARY > 3000000; 
--같은 컬럼이 아니더라도 컬럼의 개수와 자료형이 같으면 오류가 나지는 않으나, 제대로된 결과SET 반환 x

-- 3.UNION ALL
-- 부서코드가 'D5'인 사원 또는 급여가 300만원 초과인 사원의 사번, 사원명, 부서코드, 급여 조회
select EMP_ID, EMP_NAME, DEPT_CODE, SALARY
from EMPLOYEE
where DEPT_CODE = 'D5'
union all
select EMP_ID, EMP_NAME, DEPT_CODE, SALARY
from EMPLOYEE
where SALARY > 3000000
order by 1;

-- 4.EXCEPT
-- 부서코드가 'D5'인 사원 또는 급여가 300만원 초과인 사원의 사번, 사원명, 부서코드, 급여 조회
select EMP_ID, EMP_NAME, DEPT_CODE, SALARY
from EMPLOYEE
where DEPT_CODE = 'D5'
except 
select EMP_ID, EMP_NAME, DEPT_CODE, SALARY
from EMPLOYEE
where SALARY > 3000000
order by 1;

