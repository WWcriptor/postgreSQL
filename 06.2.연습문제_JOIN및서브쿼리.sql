-- SUBQUERY_연습문제
-- 1. 70년대 생(1970~1979) 중 여자이면서 이씨인 사원의 사원명, 주민번호, 부서명, 직급명 조회 
select EMP_NAME, EMP_NO, DEPT_TITLE, JOB_NAME
from EMPLOYEE
join DEPARTMENT on (DEPT_ID = DEPT_CODE)
join JOB using (JOB_CODE)
where substr(EMP_NO, 1, 2)::INT between 70 and 79 
and substr(EMP_NO, 8, 1) in ('2', '4') 
and EMP_NAME like '이%';

-- 2. 나이가 가장 막내의 사번, 사원명, 나이, 부서명, 직급명 조회
select EMP_ID, EMP_NAME
	,EXTRACT(year from CURRENT_DATE) - EXTRACT(year from TO_DATE(SUBSTR(EMP_NO, 1, 6),'YYMMDD')) as 나이
	,DEPT_TITLE, JOB_NAME
from EMPLOYEE
left join DEPARTMENT on (DEPT_CODE = DEPT_ID)
join JOB using(JOB_CODE)
order by 나이
limit 1;

-- 3. 이름에 ‘하’가 들어가는 사원의 사번, 사원명, 직급명 조회
select EMP_ID, EMP_NAME, JOB_NAME
from EMPLOYEE
join JOB USING(JOB_CODE)
where EMP_NAME like '%하%';
-- 4. 부서 코드가 D5이거나 D6인 사원의 사원명, 직급명, 부서코드, 부서명 조회
select EMP_NAME, JOB_NAME, DEPT_CODE, DEPT_TITLE
from EMPLOYEE
join JOB USING(JOB_CODE)
join DEPARTMENT on (DEPT_CODE = DEPT_ID)
where DEPT_CODE in ('D5', 'D6');

-- 5. 보너스를 받는 사원의 사원명, 보너스, 부서명, 지역명 조회
select EMP_NAME, BONUS, DEPT_TITLE, LOCAL_NAME
from EMPLOYEE
join DEPARTMENT on (DEPT_CODE = DEPT_ID)
join location on (LOCAL_CODE = LOCATION_ID)
where BONUS is not null;
-- 6. 모든 사원의 사원명, 직급명, 부서명, 지역명 조회
select EMP_NAME, JOB_NAME, DEPT_TITLE, local_NAME
from EMPLOYEE
left join DEPARTMENT on (DEPT_CODE = DEPT_ID)
left join location on (LOCAL_CODE = location_ID)
join JOB USING(JOB_CODE);
-- 7. 한국이나 일본에서 근무 중인 사원의 사원명, 부서명, 지역명, 국가명 조회 
select EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
from EMPLOYEE
join DEPARTMENT on (DEPT_CODE = DEPT_ID)
join location on (LOCAL_CODE = LOCATION_ID)
join national USING(NATIONAL_CODE)
where NATIONAL_NAME in ('한국', '일본');
-- 8. 하정연 사원과 같은 부서에서 일하는 사원의 사원명, 부서코드 조회
select EMP_NAME, DEPT_CODE
from EMPLOYEE
where DEPT_CODE = (select DEPT_CODE from EMPLOYEE where EMP_NAME = '하정연');
-- 9. 보너스가 없고 직급 코드가 J4이거나 J7인 사원의 사원명, 직급명, 급여 조회
select EMP_NAME, JOB_NAME, SALARY
from EMPLOYEE
join JOB USING(JOB_CODE)
where BONUS is null and JOB_CODE in ('J4','J7');
-- 10. 퇴사 하지 않은 사람과 퇴사한 사람의 수 조회
select ENT_YN, count(*)
from EMPLOYEE
group by ENT_YN;
-- 11. 보너스 포함한 연봉이 높은 5명의 사번, 사원명, 부서명, 직급명, 입사일, 순위 조회
select EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, HIRE_DATE, ROW_NUMBER() OVER(order by SALARY*12*coalesce(1+BONUS, 1) DESC)
from EMPLOYEE
join JOB USING(JOB_CODE)
left join DEPARTMENT on (DEPT_ID = DEPT_CODE)
limit 5; 
-- 12. 부서 별 급여 합계가 전체 급여 총 합의 20%보다 많은 부서의 부서명, 부서별 급여 합계 조회
--	12-1. JOIN과 HAVING 사용
select DEPT_TITLE, SUM(SALARY)
from EMPLOYEE
join DEPARTMENT on (DEPT_CODE = DEPT_ID)
group by DEPT_TITlE
having SUM(SALARY) > (select sum(SALARY) from EMPLOYEE)*0.2;
--	12-2. 인라인 뷰 사용
select DEPT_TITLE, 부서합계
from (select DEPT_TITLE, SUM(SALARY) as 부서합계
		from EMPLOYEE
		join DEPARTMENT on (DEPT_CODE = DEPT_ID)
		group by DEPT_TITLE) A
where (select SUM(SALARY) from EMPLOYEE)*0.2 < A.부서합계;
--	12-3. WITH 사용
with TOTAL_SAL as (select DEPT_TITLE, SUM(SALARY) as 부서합계
					from EMPLOYEE
					join DEPARTMENT on (DEPT_ID = DEPT_CODE)
					group by DEPT_TITLE)
select DEPT_TITLE, 부서합계
from TOTAL_SAL
where 부서합계 > (select SUM(salary) from EMPLOYEE)*0.2;

-- 13. 부서명별 급여 합계 조회(NULL도 조회되도록)
select DEPT_TITLE, SUM(SALARY)
from DEPARTMENT
left join EMPLOYEE on (DEPT_ID = DEPT_CODE)
group by DEPT_ID
order by DEPT_ID;

-- 14. WITH를 이용하여 급여합과 급여평균 조회
with PLOT as (select SUM(SALARY)as 급여합, ROUND(AVG(SALARY),-1) as 급여평균
				from EMPLOYEE)
select 급여합, 급여평균
from PLOT;




