/*
  <SUBQUERY>
  - 하나의 SQL문 안에 포함된 또 다른 SELECT문
  - 메인 SQL을 위해 보조 역할을 하는 쿼리문
 */

-- 박서준과 같은 부서에 속한 사원들 조회
-- 1. 박서준의 부서코드 조회
select DEPT_CODE
from EMPLOYEE
where EMP_NAME = '박서준'; --D9

-- 부서가 D9인 사원들 조회
select EMP_NAME
from EMPLOYEE
where DEPT_CODE = 'D9';

select EMP_NAME
from EMPLOYEE
where DEPT_CODE = (select DEPT_CODE from EMPLOYEE where EMP_NAME = '박서준');

-- 전 직원의 평균 급여보다 더 많은 급여를 받는 사원들의 사번, 사원명, 급여 조회
-- 1. 평균 급여
select AVG(SALARY)
from EMPLOYEE; -- 3047662 

-- 2. 급여가 평균(3047662)보다 많이 받는 사람
select EMP_ID, EMP_NAME, SALARY
from EMPLOYEE
where SALARY > 3047662;

select EMP_ID, EMP_NAME, SALARY
from EMPLOYEE
where SALARY > (select AVG(SALARY) from EMPLOYEE);


---------------------------------------------------------
/*
  서브쿼리 구분
  	:서브쿼리를 수행한 결과값이 몇 행 몇 열이냐에 따라 구분
  	
  	-단일행 서브쿼리 : 서브쿼리의 결과값이 오로지 1개일 때 (1행 1열)
  	-다중행 서브쿼리 : 서브쿼리의 결과값이 여러행 일때(여러행 1열)
  	-다중열 서브쿼리 : 서브쿼리의 결과값이 여러열 일때(1행 여러열)
  	-다중행 다중열 서브쿼리 : 서브쿼리의 결과값이 여러행 여러열 일 떄(여러행 여러열)
  	
  	>> 서브쿼리의 종류에따라 서브쿼리 앞에 붙는 연산자가 달라짐
 */

/*
  	1. 단일행 서브쿼리(SINGLE ROW SUBQUERY)
   	: 서브쿼리의 결과값이 오로지 1개일 때 (1행 1열)
   	
   	일반 비교 연산자 사용 가능
   	=, !=, >,....
 */

-- 1) 전 직원의 평균급여보다 급여를 적게 받는 사원들의 사원명, 직급코드, 급여 조회
select EMP_NAME, JOB_CODE, SALARY
from EMPLOYEE
where SALARY < (select AVG(SALARY) from EMPLOYEE)
order by SALARY; 

-- 2) 최저급여를 받는 사원의 사번, 사원명, 급여, 입사일 조회
select EMP_ID, EMP_NAME, SALARY, HIRE_DATE
from EMPLOYEE
where SALARY = (select MIN(SALARY) from EMPLOYEE);

-- 3) 조정연 사원의 급여보다 더 많이 받는 사원의 사번, 사원명, 부서코드, 급여 조회
select EMP_ID, EMP_NAME, DEPT_CODE, SALARY
from EMPLOYEE
where SALARY > (select SALARY from EMPLOYEE where EMP_NAME = '조정연');

-- JOIN
-- 4) 조정연 사원의 급여보다 더 많이 받는 사원의 사번, 사원명, 부서명, 급여 조회
select EMP_ID, EMP_NAME, DEPT_TITLE, SALARY
from EMPLOYEE
join DEPARTMENT on (DEPT_ID = DEPT_CODE)
where SALARY > (select SALARY from EMPLOYEE where EMP_NAME = '조정연');

-- 5) 왕건우 사원과 같은 부서원들의사번, 사원명, 전화번호, 입사일, 부서명 조회. 왕건우는 제외
select EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_TITLE
from EMPLOYEE
join DEPARTMENT on (DEPT_CODE = DEPT_ID)
where DEPT_CODE = (select DEPT_CODE from EMPLOYEE where EMP_NAME = '왕건우') and EMP_NAME != '왕건우';

-- GROUP BY
-- 6) 부서별 급여 합계가 가장 큰 부서의 부서코드, 급여합 조회
-- 6-1) 부서별 급여의 합 중 가장 큰 값 조회
select SUM(SALARY)
from EMPLOYEE
group by DEPT_CODE
order by SUM(SALARY) desc
limit 1;

select MAX(총급여) -- 17700000
from (
	select SUM(SALARY) as 총급여 -- 별칭 필수
	from EMPLOYEE
	group by DEPT_CODE
);

-- 6-2)
select DEPT_CODE, SUM(SALARY)
from EMPLOYEE 
group by dept_code
having SUM(SALARY) = 17700000;

select DEPT_CODE, SUM(SALARY)
from EMPLOYEE 
group by dept_code
having SUM(SALARY) = (select SUM(SALARY)
						from EMPLOYEE
						group by DEPT_CODE
						order by SUM(SALARY) desc
						limit 1;)
						
------------------------------------------------------------------------
/*
  	다중행 서브쿼리
   	: 서브쿼리의 결과값이 여러행 일때(여러행 1열)
   	
   	- IN 서브쿼리 : 여러개의 결과값 중에서 한 개라도 일치하는 값이 있다면
   	> ANY 서브쿼리 : 여러개의 결과값 중에서 "한 개라도" 클 경우
   				  (여러개의 결과값 중 가장 작은 값보다 클 경우)
   	< ANY 서브쿼리 : 여러개의 결과값 중에서 "한 개라도" 작을 경우
   				  (여러개의 결과값 중 가장 큰 값보다 작을 경우)
   	비교대상 > ANY (ARRAY[값1, 값2, 값3,...])
   	비교대상 > 값1 OR 비교대상 > 값2 OR 비교대상 > 값3
   	ALL : 비교대상 > 가장 큰 값 / 비교대상 < 가장 작은 값
  */
-- 1) 조정연 또는 전지연 사원과 같은 직급인 사원들의 사번, 사원명, 직급코드, 급여 조회
-- 1.1 조정연 또는 전지연 사원의 직급
select JOB_CODE
from EMPLOYEE
where EMP_NAME in ('조정연', '전지연');
  
  -- 1.2 J3, J&인 사원들 조회
select EMP_ID, EMP_NAME, JOB_CODE, SALARY
from EMPLOYEE
where JOB_CODE in ('J3', 'J7');

select EMP_ID, EMP_NAME, JOB_CODE, SALARY
from EMPLOYEE
where JOB_CODE in (	select JOB_CODE
					from EMPLOYEE
					where EMP_NAME in ('조정연', '전지연'));

-- 2) 대리 지급임에도 불고하고 과장 직급 급여들 중 최소 급여보다 많이 받는 직원의 사번, 사원명, 직급, 급여 조회
-- 2.1 과장 직급인 사원들의 급여 조회
select SALARY
from EMPLOYEE
join JOB USING(JOB_CODE)
where JOB_NAME = '과장'; -- 220만, 250만, 376만

-- 2.2 직급이 대리이면서 급여값이 위의 목록들 중에 하나라도 큰 급여를 받는 사원 
select EMP_ID, EMP_NAME, JOB_NAME, SALARY
from EMPLOYEE
join JOB USING(JOB_CODE)
where JOB_NAME = '대리'
and SALARY > any(array[2200000,2500000,3760000]);

--> 위의 쿼리문을 하나로
select EMP_ID, EMP_NAME, JOB_NAME, SALARY
from EMPLOYEE
join JOB USING(JOB_CODE)
where JOB_NAME = '대리'
and SALARY > any(select SALARY
			from EMPLOYEE
			join JOB USING(JOB_CODE)
where JOB_NAME = '과장');

--> 단일행 쿼리로도 가능
select EMP_ID, EMP_NAME, JOB_NAME, SALARY
from EMPLOYEE
join JOB USING(JOB_CODE)
where JOB_NAME = '대리'
and SALARY > any(select MIN(SALARY)
			from EMPLOYEE
			join JOB USING(JOB_CODE)
where JOB_NAME = '과장');

-- 차장 직급임에도 과장 직급의 급여보다 적게 받는 사원의 사번 ㅅ원명, 직급, 급여 조회
select EMP_ID, EMP_NAME, JOB_NAME, SALARY
from EMPLOYEE
join JOB using(JOB_CODE)
where JOB_NAME = '차장'
	and SALARY <ANY(select SALARY from EMPLOYEE join JOB using(JOB_CODE) where JOB_NAME = '과장');

-- 4) 과장 직급임에도 차장 직급인 사원들의 모든 급여보다 더 많이 받는 사원의 사번, 사원명, 직급명, 급여 조회
select EMP_ID, EMP_NAME, JOB_NAME, SALARY
from EMPLOYEE
join JOB USING(JOB_CODE)
where JOB_NAME = '과장' and SALARY > ANY (select SALARY from EMPLOYEE join JOB USING(JOB_CODE) where JOB_NAME = '차장');


-- 차장의 가장 많이 받는 급여보다 더 많이 받는 과장
select EMP_ID, EMP_NAME, JOB_NAME, SALARY
from EMPLOYEE
join JOB USING(JOB_CODE)
Where JOB_NAME = '과장'
and SALARY > ALL(select SALARY from EMPLOYEE join JOB USING(JOB_CODE) where JOB_NAME = '차장');


--------------------------------------------------
/*
  	3. 다중열 서브쿼리
  		: 한 행, 여러 열
  		
 */
-- 1) 장예은 사원과 같은 부서코드, 같은 직급 코드에 해당하는 직원들의 사원명, 부서코드, 직급코드, 입사일 조회
select EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
from EMPLOYEE
where DEPT_CODE = (select DEPT_CODE from EMPLOYEE where EMP_NAME = '장예은')
and JOB_CODE = (select JOB_CODE from EMPLOYEE where EMP_NAME = '장예은');

--다중열 서브쿼리로
select EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
from EMPLOYEE
where (DEPT_CODE, JOB_CODE) = (select DEPT_CODE, JOB_CODE from EMPLOYEE where EMP_NAME = '장예은');

-- 지민재 사원과 같은 직급코드, 같은 사수를 가지고 있는 사원들의 사번, 사번명, 직급코드, 사수번호 조회
select EMP_ID , EMP_NAME, JOB_CODE, MANAGER_ID
from EMPLOYEE
where (JOB_CODE, MANAGER_ID) = (select JOB_CODE, MANAGER_ID from EMPLOYEE where EMP_NAME = '지민재');


----------------------------------------------------------
/*
  4. 다중행 다중열 서브쿼리
  	:여러행 여러열
*/
-- 1) 각 직급별 최소 급여 금액을 받는 사원들의 사번, 사원명, 직급코드, 급여 조회
-- 1-1 각 직급별 최소금액과 직급코드
select JOB_CODE, MIN(SALARY)
from EMPLOYEE
group by JOB_CODE
order by 1;

select EMP_ID, EMP_NAME, JOB_CODE, SALARY
from EMPLOYEE
group by JOB_CODE = 'J1' and SALARY = 8000000
	  or JOB_CODE = 'J2' and SALARY = 3700000
	  ......;
	  
select EMP_ID, EMP_NAME, JOB_CODE, SALARY
from EMPLOYEE
where (JOB_CODE, SALARY) = ('J1', 8000000)
   or (JOB_CODE, SALARY) = ('J2', 3700000)
	  ....;

-->> 서브쿼리 적용
select EMP_ID, EMP_NAME, JOB_CODE, SALARY
from EMPLOYEE
where (JOB_CODE, SALARY) in (select JOB_CODE, MIN(SALARY) from EMPLOYEE group by JOB_CODE)
order by JOB_CODE;

-- 2) 각 부서별 최고 급여를 받는 사원들의 사번, 사원명, 부서코드, 급여 조회
select EMP_ID, EMP_NAME, DEPT_CODE, SALARY
from EMPLOYEE
where (DEPT_CODE, SALARY) in (select DEPT_CODE, MAX(SALARY) from EMPLOYEE group by DEPT_CODE)
order by DEPT_CODE;


-------------------------------------------------------------------------
/*
 5. INLINE VIEW
 	FROM 절에 서브쿼리 작성
 	서브쿼리를 수행한 결과를 마치 테이블처럼 사용
 	
 	 postgre 16버전 이상은 인라인뷰에 별칭을 붙이지 않아도 알아서 매칭
 	 postgre 16버전 미만이거나 다른 DBMS(My SQL 등)은 반드시 별칭을 붙여줘야 함 
 */
-- 사원들의 사번, 이름, 보너스를 포함한 연봉(별칭 부여), 부서코드 조회
-- 단, 보너스 포함 연봉이 3000만원 이상인 사원들만 조회

select EMP_ID, EMP_NAME, SALARY*12*(1+coalesce(BONUS, 0)) as 연봉, DEPT_CODE
from EMPLOYEE
where SALARY*12*(1+coalesce(BONUS, 0)) > 40000000;

-- where절에 별칭을 사용하려면 INLINE VIEW 사용
select E.EMP_NAME, E.연봉
from (select EMP_ID, EMP_NAME, SALARY*12*(1+coalesce(BONUS, 0)) as 연봉, DEPT_CODE
		from EMPLOYEE) E
where E.연봉 >= 40000000;
-- INLINE VIEW 서브쿼리의 컴럼명만 메인 쿼리에서 호출 가능

--------------------------------------------------------------------------------
/*
   6. WITH
   		서브쿼리에 이름을 붙여주고 인라인 뷰로 사용시 서브쿼리의 이름으로 FROM 절에 기술 가능
   		
   		WITH 이름(마음대로) AS (서브쿼리)
   		최종실행 메인 쿼리;
   		
   		WITH 이름(마음대로) AS (서브쿼리),
   			 이름(마음대로) AS (서브쿼리)
   		최종실행 메인 쿼리;
 */

with TOPN_SAL1 as (select DEPT_CODE, ROUND(AVG(SALARY)) as 평균급여 
					 from EMPLOYEE
					group by DEPT_CODE 
					order by 2 desc 
					limit 2)
select DEPT_CODE, 평균급여
from TOPN_SAL1;

------------------------------------------------------------------------------------
/*
  7. 순위 매기는 함수(WINDOW FUNCTION)
  	RANK() OVER(정렬기준) | DENSE_RANK() OVER(정렬기준)
  	- RANK() OVER(정렬기준) : 동일한 순위 이후의 등수를 동일한 인원수 만큼 건너뛰고 순위 계산
  						EX) 공동1위가 2명이면 그 다음 순위는 3위
  	- DENSE_RANK() OVER() : 동일한 순위가 있어도 다음 등수는 무조건 1씩 증가
  						EX) 공동1위가 2명이어도 그 다음 순위는 2위
  	>> SELECT절에서만 사용 가능
 */
-- 급여가 높은 순서대로 순위를 매겨서 사원명, 급여, 순위 조회
select EMP_NAME, SALARY, RANK() OVER(order by SALARY DESC) as 순위
from EMPLOYEE;

select EMP_NAME, SALARY, DENSE_RANK() OVER(order by SALARY DESC) as 순위
from EMPLOYEE;

-- 급여가 상위 5위인 사원의 사원명, 급여, 순위 조회
select EMP_NAME, SALARY, RANK() OVER(order by SALARY DESC) as 순위
from EMPLOYEE;
--where RANK() OVER(order by SALARY DESC) = 5 -- 오류

select *
from (select EMP_NAME, SALARY, RANK() OVER(order by SALARY DESC) as 순위
from EMPLOYEE)
where 순위 = 5;

-->> WITH로 사용
with TOPN_SAL as (select EMP_NAME, SALARY, RANK() OVER(order by SALARY DESC) as 순위
					from EMPLOYEE)					
select *
from TOPN_SAL
where 순위 = 5;

-- >> TOP-N 분석
/*
  원하는 기능
  -------------------
  상위 5개 			LIMIT 5
  상위 3개			LIMIT 3
  상위 6~9위			LIMIT 4 OFFSET 5 : 5만큼 떨어뜨려(OFFSET)서 4개 가져오기
  결과에 순번 출력		ROW_NUMBER() OVER(정렬기준)
  표준 SQL 상위 5개 	FATCH FIRST 5 ROWS ONLY
 */

-- 급여가 높은 상위 5명 조회
select EMP_NAME, SALARY
from EMPLOYEE
order by SALARY desc
limit 5;

select row_number() over(order by SALARY DESC) as 순위, EMP_NAME, SALARY
from EMPLOYEE
order by SALARY desc
limit 5;

--가장 최근에 입사한 사원 5명의 사원명, 급여, 입사일 조회
select EMP_NAME, SALARY, HIRE_DATE
from EMPLOYEE
order by HIRE_DATE desc
limit 5;

-- 부서별 평균 급여가 높은 상위 3개 부서 조회
select row_number() over(order by AVG(SALARY) desc) as 순위, DEPT_TITLE, ROUND(AVG(SALARY)) as 평균급여
from EMPLOYEE
join DEPARTMENT on (DEPT_CODE = DEPT_ID)
group by DEPT_TITLE
order by AVG(SALARY) desc
limit 3;

-- 급여가 높은 상위 6위 ~ 8위까지 조회
select EMP_NAME, SALARY
from EMPLOYEE
order by SALARY desc
limit 4 offset 5;

--INLINE VIEW가 필요할 때
select EMP_NAME, SALARY
from EMPLOYEE
order by SALARY
limit 4;
-- 5위가 2명이어도 5행만 가져옴
-- 정확히 가져오려면 INLINE VIEW 사용해야 함

select *
from (select EMP_NAME, SALARY, DENSE_RANK() OVER(order by SALARY) as 순위 from EMPLOYEE)
where 순위 <=4;

-- 2) 집계(GROUP BY)후 다른 테이블과 JOIN 하고자 할 떄
-- 부서별 평균급여를 구한 뒤 부서 정보와 조인
select *
from (select DEPT_CODE, ROUND(AVG(SALARY), -1) as 평균급여 from EMPLOYEE group by DEPT_CODE)
join DEPARTMENT on (DEPT_CODE = DEPT_ID);

-- 3) 급여 구간별 인원수 집계
select 급여구간, COUNT(*) as 인원수
from (select EMP_NAME,
		case when SALARY >= 5000000 then '고급급여'
			when SALARY >= 3000000 then '중급급여'
			else '초급급여'
		end as 급여구간
		from EMPLOYEE)
group by 급여구간;

-- 4) 사원명, 급여, 부서평균
select EMP_NAME, SALARY, 부서평균
from EMPLOYEE
left join (select DEPT_CODE, ROUND(AVG(SALARY), -1) as 부서평균
		from EMPLOYEE
		group by DEPT_CODE) USING(DEPT_CODE);



