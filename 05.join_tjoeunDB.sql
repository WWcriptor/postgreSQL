/*
   <JOIN>
   두 개 이상의 테이블에서 데이터를 조회하고자 할 떄 사용하는 구문
   조히 결과는 하나의 결과물(RESULT SET)로 나옴
   
    - 관계형 데이터베이스는 최소한의 데이터로 각각의 테이블에 담고 있어야 함
    (중복제거를 위해)
    => 관계형 데이터베이스에서 SQL문을 이용하여 테이블간의 '관계'를 맺는 방법
    
     [JOIN 용어 정리]
     1. 내부조인(INNER JOIN) 	=> JOIN ON / JOIN USING
     	자연조인(NATURAL JOIN) => 동일한 컬럼을 자동 조인 
     2. 외부조인(OUTER JOIN)
     	- 왼쪽 외부 조인(LEFT OUTER JOIN / LEFT JOIN)
     	- 오른쪽 외부 조인(RIGHT OUTER JOIN / RIGHT JOIN)
     	- 전체 외부 조인(FULL OUTER JOIN / FULL JOIN)
     3. 비등가 조인(NON-EQUAL JOIN) => JOIN ON (동등 '=' 비교가 아닌 조인)
     4. 자체 조인(SELF JOIN)		 => JOIN ON (같은 테이블끼리 조인)
     5. 교차 조인(CROSS JOIN)		 => 모든 경우의 수 / 카테시안 곱
 */
-- 전체 사원들의 사번, 사원명, 부서코드, 부서명을 조회하고자 한다.
select EMP_ID, EMP_NAME, DEPT_CODE
from EMPLOYEE;

select DEPT_ID, DEPT_TITLE
from DEPARTMENT;

-- ===========================================================
/*
 1. 등가조인(EQUAL JOIN) / 내부조인(INNER JOIN)
 	연결시키는 컬럼의 값이 "일치하는 행들만" 조인이 되어 조회 
 */
------------------------------------------------------------------
-- 1) 연결할 두 컬럼명이 다른 경우
--	=> 오직 JOIN ON 구문만 사용 가능
-- EMPLOYEE : DEPT_CODE / DEPARTMENT : DEPT_ID
select EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
from EMPLOYEE, DEPARTMENT;
-- DEPARTMENT 행당 23명씩 총 207행 생성

select EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
from EMPLOYEE
join DEPARTMENT on (DEPT_CODE = DEPT_ID);

-- 2) 연결할 두 컬럼명이 같은 경우
--	=> JOIN ON 또는 JOIN USING 구문 사용 가능
-- EMPLOYEE : JOB_CODE / JOB : JOB_CODE
select EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
from EMPLOYEE E
join JOB J on (E.JOB_CODE =J.JOB_CODE); 
-- 중복된 이름일경우 어느 테이블의 칼럼 이름인지를 명시해야 함

-- JOIN USING : 컬럼명이 같을 떄만 사용 가능
select EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
from EMPLOYEE
join JOB USING(JOB_CODE);


-----------------------------------------------------
-- 3) NATURAL JOIN
-- 두 테이블에서 이름이 같은 컬럼을 자동으로 찾아서 매칭해줌
	select EMP_NO, EMP_NAME, JOB_CODE, JOB_NAME
	from EMPLOYEE
	natural join JOB;

-----------------------------------------------------
-- 4) 조인과 함께 조건 제시
-- 직급이 대리인 사원들의 사번, 이름, 직급명, 급여 조회
select EMP_ID, EMP_NAME, JOB_NAME, SALARY
from EMPLOYEE e
join JOB j on (E.JOB_CODE=j.JOB_CODE)
where JOB_NAME = '대리';

select EMP_ID, EMP_NAME, JOB_NAME, SALARY
from EMPLOYEE
join JOB using (JOB_CODE)
where JOB_NAME = '대리';

--
-- 1. 부서가 인사관리부인 사워들의 사번, 사원명, 부서명, 보너스 조회
select EMP_ID, EMP_NAME, DEPT_TITLE, BONUS
from DEPARTMENT
join EMPLOYEE on (DEPT_ID = DEPT_CODE)
where DEPT_TITLE = '인사관리부';
-- 2. DEPARTMENT와  LOCATION 테이블을 참조하여 부서코드, 부서명, 지역코드, 지역명 조회
select DEPT_ID, DEPT_TITLE, LOCATION_ID, LOCAL_NAME
from DEPARTMENT
join location on (LOCATION_ID = LOCAL_CODE);

-- 3. 보너스를 받은 사원들의 사번, 사원명, 보너스, 부서명 조회
select EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
from EMPLOYEE
join DEPARTMENT on (DEPT_ID = DEPT_CODE)
where BONUS is not null;

-- 4. 부서가 총무부가 아닌 사원들의 사원명, 급여, 부서명 조회 
select EMP_NAME, SALARY, DEPT_TITLE
from EMPLOYEE
join DEPARTMENT on (DEPT_ID = DEPT_CODE)
where DEPT_TITLE <> '총무부'

-- ===============================================================
/*
  2. 외부 조인 / 포괄 조인
  	두 테이블간의 JOIN시 일치하지 않는 행도 포함시켜 조히
  	단, 어느 테이블을 기준으로 할지 LEFT / RIGHT / FULL 중 하나를 지정 
 */

-- 사원명, 부서명, 급여, 연봉
select EMP_NAME, DEPT_CODE, DEPT_TITLE, SALARY, SALARY*12
from EMPLOYEE
join DEPARTMENT on (DEPT_ID = DEPT_CODE)
order by 2;
-- 부서배치가 안 된 사원 정보 X
-- 사원이 배정되지 않은 부서도 조회 X

-- LEFT [OUTER] JOIN
select EMP_NAME, DEPT_CODE, DEPT_TITLE, SALARY, SALARY*12
from EMPLOYEE
left join DEPARTMENT on (DEPT_CODE = DEPT_ID);

-- RIGHT [OUTER] JOIN
select EMP_NAME, DEPT_ID, DEPT_TITLE, SALARY, SALARY*12
from employee
right join DEPARTMENT on (DEPT_CODE = DEPT_ID)
order by DEPT_ID;

-- FULL [OUTER] JOIN
select EMP_NAME, DEPT_CODE, DEPT_TITLE, SALARY, SALARY*12
from EMPLOYEE
full join DEPARTMENT on (DEPT_CODE = DEPT_ID);

-- ===============================================================
/*
  3. 비등가 조인
  	매칭시킬 컬럼의 조건 작성시 '='을 사용하지 않는 JOIN문
  	=> JOIN ON으로만 가능
 */

--SAL_GRADE 테이블 조인(SAL_LEVEL컬럼)
select EMP_NAME, SALARY
from EMPLOYEE;

-- 사원명, 급여, 급여등급 조회
select EMP_NAME, SALARY, SAL_LEVEL
from employee
join SAL_GRADE on (SALARY >= MIN_SAL and SALARY <= MAX_SAL);

select EMP_NAME, SALARY, SAL_LEVEL
from employee
join SAL_GRADE on (SALARY between MIN_SAL and MAX_SAL);

-- =======================================================
/*
  4. 자체조인
  	같은 테이블을 다시 조회  
 */
-- 사수가 있는 사원만 조회
select EMP_ID, EMP_NAME, MANAGER_ID
from EMPLOYEE
where MANAGER_ID is not null;

-- 사수가 있는 사원의 정보(사번, 이름, 부서코드)와 사수의 정보를 조회
select E.EMP_ID, E.EMP_NAME, E.DEPT_CODE,
		M.EMP_ID, M.EMP_NAME, M.DEPT_CODE
from EMPLOYEE E, EMPLOYEE M
where E.MANAGER_ID = M.EMP_ID;

-- >> 전체 사원의 사수 조회(정보는 위와 같음)
select E.EMP_ID, E.EMP_NAME, E.DEPT_CODE,
		M.EMP_ID, M.EMP_NAME, M.DEPT_CODE
from employee E
left join EMPLOYEE M on (E.MANAGER_ID = M.EMP_ID);


-- ========================================================
/*
  <다중 JOIN>
  	2개 이상의 테이블을 가지고 JOIN 할 때 
 */
-- EMPLOYEE 테이블의 전 사원들의 사번, 사원명, 부서명, 직급명 조회

-- 서로 매칭
/*
  EMPLOYE		DEPT_CODE	JOB_CODE
  DEPARTMENT	DEPT_ID
  JOB						JOB_CODE
 */

select EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
from EMPLOYEE
left join DEPARTMENT on (DEPT_CODE = DEPT_ID)
join JOB using(JOB_CODE);

-- 사번, 사원명, 부서명, 지역명 조회
/*
  EMPLOYEE		DEPT_CODE
  DEPARTMENT	DEPT_ID		LOCATION_ID
  LOCATION					LOCAL_CODE
 */

--21명 조회
select EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME
from EMPLOYEE
join DEPARTMENT on (DEPT_CODE = DEPT_ID)
join location on (LOCATION_ID = LOCAL_CODE);

-- 전 사원
select EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME
from EMPLOYEE
left join DEPARTMENT on (DEPT_CODE = DEPT_ID)
left join location on (LOCATION_ID = LOCAL_CODE);


----------------------- 실습문제 -----------------------
-- 1. 사번, 사원명, 부서명, 지역명, 국가명 조회
-- (EMPLOYEE, DEPARTMENT, LOCATION, NATIONAL)
select EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
from EMPLOYEE
join DEPARTMENT on (DEPT_CODE = DEPT_ID)
join location on (LOCATION_ID = LOCAL_CODE)
join national USING (NATIONAL_CODE);

-- 2. 사번, 사원명, 부서명, 직급명, 지역명, 국가명, 급여등급 조회
-- (모든 테이블)
select EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, LOCAL_NAME, NATIONAL_NAME, SAL_LEVEL
from EMPLOYEE
left join DEPARTMENT on (DEPT_ID = DEPT_CODE)
join JOB USING(JOB_CODE)
left join location on (LOCAL_CODE = LOCATION_ID)
left join national using (NATIONAL_CODE)
join SAL_GRADE on (SALARY between MIN_SAL and MAX_SAL);




