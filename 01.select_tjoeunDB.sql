/*
 여러 줄 주석 : ctrl + shift+/

*/

-- 한 줄 주석 : ctrl + /
/*
 * DML(Data Manipulation Language):데이터 조작 언어
 * :테이블의 값을 검색(select), 삽입(insert), 수정(update), 삭제(delete)하는 구문
 * */
-- =================================================================
/*
 	(') 홑따옴표 : 문자열을 감싸는 기호
 	(") 쌍따옴표 : 컬럼명 등을 감싸주는 기호
*/

/*
 <select>
 	데이터를 조회할 때 사용
 	>>Result set : 행들의 집합
 	
 	[표현법]
 	SELECT 조회하고자하는 컬럼, 컬럼,....
 	FROM 테이블명;
 * */

-- EMPLOYEE 테이블에 있는 모든 컬럼(*) 조회
select *
from employee;

-- EMPLOYEE 테이블에서 사번, 이름, 급여 조회
select emp_id, emp_name, salary
from employee;

-- JOB 테이블에 있는 모든 컬럼 조회
select *
from JOB;

-- 실습문제 --
-- 1. JOB 테이블에서 직급명만 조회
select JOB_NAME
from JOB;

-- 2. DEPARTMENT 테이블에서 모든 컬럼 조회
select *
from DEPARTMENT;

-- 3. DEPARTMENT 테이블에서 테이블의 부서코드, 부서명 조회
select dept_id, dept_title
from DEPARTMENT;

-- 4. EMPLOYEE 테이블에서 사번, 사원명, 이메일, 전화번호, 입사일, 급여 조회
select emp_id, EMP_NAME, EMAIL, PHONE, HIRE_DATE, SALARY
from EMPLOYEE;


/*
 <컬럼값을 통한 산술 연산>
 SELECT 절 컬럼명 작성 부분에 산술연산 쓸 수 있다.
 **/
-- EMPLOYEE 테이블에서 사원명, 사원의 연봉 조회
select EMP_NAME, SALARY*12
from EMPLOYEE;

-- EMPLOYEE 테이블에서 사원명, 보너스, 급여 조회
select EMP_NAME, BONUS, SALARY
from EMPLOYEE;

-- EMPLOYEE에서 사원명 급여 보너스 연봉, 보너스가 포함된 연봉을 조회
select EMP_NAME, SALARY, BONUS, SALARY*12, ((BONUS*SALARY) + SALARY)*12
from EMPLOYEE;

--EMPLOYEE에서 사원명, 입사일, 근무일수
--DATE 형식끼리 연산 가능 : +, -
-- 오늘 날짜는 CURRENT_DATE
select EMP_NAME, HIRE_DATE, CURRENT_DATE - HIRE_DATE
from EMPLOYEE;

-----------------------------------------------------------------------------------------

/*
 <컬럼명에 별칭 지정하기>
산술연산시 컬럼명이 ?column?으로 나올 때 별칭 부여하여 처리할 수 있음 

[표현법]
컬럼명 별칭 / 컬럼명 as 별칭 / 컬럼명 "별칭" / 컬럼명 as "별칭"

반드시 별칭에 쌍따옴표(")가 들어가야 할 때
  -> 별칭에 띄어쓰기, 특수 문자가 포함되어 있는 경우.
 */

select EMP_NAME, SALARY, BONUS, SALARY*12 연봉, ((BONUS*SALARY) + SALARY)*12 "총 소득"
from EMPLOYEE;

select EMP_NAME, SALARY, BONUS, SALARY*12 "연봉(원)", ((BONUS*SALARY) + SALARY)*12 "총 소득"
from EMPLOYEE;

-------------------------------------------------------------
/*
 <리터럴>
 임의로 지정한 문자열(')
 
 SELECT절에 리터럴을 제시하면 마치 테이블상에 존재하는 데이터처럼 조회 가능
 조회된 result set의 모든 행에 반복적으로 같이 출력
 */

-- employee에 사번, 사원명, 급여 조회.
select emp_id, emp_name, salary, '원' as 단위
from EMPLOYEE;

-----------------------------------------------------
/*
 <연결 연산자 : ||> 
 	여러 컬럼값들을 마치 하나의 컬럼인 것처럼 연결하거나 커럼값과 리터럴을 연결할 수 있음
 	숫자를 그냥 결합하면 TypeError 발생
 	숫자형을 문자로 명시적 변환(::text)
 */

-- EMPLOYEE 테이블에서 사번, 이름, 급여를 하나의 컬럼으로 조회
select emp_id || emp_name || salary as 사번이름급여
from EMPLOYEE;

-- 컬럼값과 리터럴을 연결
select emp_name || '의 월급은' || salary || '원 입니다.' as message
from EMPLOYEE;

------------------------------------------------------
/*
  <DISTINCT>
  컬럼에 중복된 값들을 한 번씩만 표시하고자 할 때. 
*/
-- EMPLOYEE 에서 직급코드 조회
select JOB_CODE
from EMPLOYEE;

-- 위에서 중복 제거
select distinct JOB_CODE
from EMPLOYEE;

-- 부서코드도 중복 제거
select distinct DEPT_CODE from EMPLOYEE;

-- distinct는 select절에 딱 한 번만 기술할 수 있음
-- DEPT_CODE, JOB_CODE로 이루어진 쌍을 기준으로 중복 제거함
select distinct DEPT_CODE, JOB_CODE from EMPLOYEE; 

--------------------------------------------------------------

/*
 <WHERE 절>
 조회하고자 하는 테이블로부터 특정 조건에 만족하는 데이터만 조회할 때
 WHERE절에 조건식을 씀
 조건식에는 다양한 연산자 사용 가능
 
 [표현법]
 SElECT 컬럼, 컬럼, 컬럼...
 FROM 테이블명
 WHERE 조건식;
 
 * 비교 연산자
   <,>,<=,> : 대소비교
   = : 같은지(두 번 아님) 비교
   !=, <> : 같지 않은지 비교
 **/

-- EMPLOYEE에서 부서 코드가 'D9'인 사원의 모든 컬럼을 조회하시요
select *
from EMPLOYEE
where dept_code='D9';

-- EMPLOYEE에서 부서 코드가 'D1'인 사원의 사원명, 급여, 부서코드 조회
select EMP_NAME, SALARY, DEPT_CODE
from EMPLOYEE
where DEPT_CODE = 'D1';

-- EMPLOYEE에서 부서 코드가 'D1'이 아닌 사원의 사워명, 급여, 부서코드 조회
select EMP_NAME, SALARY, DEPT_CODE
from EMPLOYEE
where DEPT_CODE <> 'D1';

-- EMPLOYEE에서 급여가 400만원 이상인 사원의 사원명, 급여, 입사일 조회
select EMP_NAME, SALARY, HIRE_DATE
from employee
where SALARY >= 4000000;

--EMPLOYEE 에서 재직중인 사람의 사번, 사원명, 입사일, 퇴직 여부 조회
select EMP_ID, EMP_NAME, HIRE_DATE, ENT_YN
from EMPLOYEE
where ENT_YN = 'N';

---------------------실습 문제-------------------
--1. 급여가 300만원 이상인 사원들의 사원명, 급여, 입사일, 연봉 조회
select EMP_NAME, SALARY, HIRE_DATE, SALARY*12 as 연봉
from EMPLOYEE
where SALARY >= 3000000;

--2. 연봉이 5000만원 이상인 사원들의 사원명, 급여, 연봉, 부서코드 조회
select EMP_NAME, SALARY, SALARY*12 as 연봉, DEPT_CODE
from EMPLOYEE
where SALARY*12 >= 50000000;

--3. 직급 코드가 'J3'이 아닌 사람들의 사번, 사원명, 직급코드, 퇴사여부 조회
select EMP_ID, EMP_NAME, JOB_CODE, ENT_YN
from EMPLOYEE
where JOB_CODE <> 'J3';

----------------------------------------------------------
/*
  <논리 연산자>
  여러 조건을 제시하고자 할 때
  
  AND (~이면서, 그리고)
  OR (~이거나, 또는)
 */
-- 부서코드가 'D9'이면서 급여가 500만원 이상인 사원의 사원명, 부서코드, 급여 조회
select EMP_NAME, DEPT_CODE, SALARY
from EMPLOYEE
where DEPT_CODE = 'D9' and SALARY >= 5000000;

-- 부서코드가 'D6'이거나 급여가 300만원 이상인 사원의 사원명, 부서코드, 급여 조회
select EMP_NAME, DEPT_CODE, SALARY
from EMPLOYEE
where DEPT_CODE ='D6' or SALARY >=3000000;

-- 급여가 350만원 이상, 600만원이하인 사원들의 사원명, 사번, 급여 조회
select EMP_NAME, EMP_ID, SALARY
from EMPLOYEE
where SALARY >=3500000 and SALARY <= 6000000;

----------------------------------------------------------------
/*
   <BETWEEN AND>
   조건식에서 사용되는 구문으로
   ~ 이상 ~ 이하인 범위에 대한 조건을 제시할 떄 사용되는 연산자
   
   [표현법]
   비교대상 컬럼 BETWEEN 하한값 AND 상한값
 */

-- 급여가 350만원 이상, 600만원이하인 사원들의 사원명, 사번, 급여 조회
select EMP_NAME, EMP_ID, SALARY
from EMPLOYEE
where SALARY between 3500000 and 6000000;

-- 급여가 350만원 이상, 600만원이하가 '아닌' 사원들의 사원명, 사번, 급여 조회
select EMP_NAME, EMP_ID, SALARY
from EMPLOYEE
where not SALARY between 3500000 and 6000000;


-- 입사일이 1990년 1월 1일 ~ 2004년 12월 31일 사이에 입사한 사람들만
select*
from EMPLOYEE
where HIRE_DATE between '1990-01-01'and'2004-12-31';

----------------------------------------------------------------
/*
   <LIKE>
   비교하고자 하는 컴럼 값이 내가 제시한 특정 패턴에 만족하는 경우 조회
   
   [표현법]
   비교대상컬럼 LIKE '특정 패턴'
   : '특정패턴'에는 와일드 카드(%,_)로 쓸 수 있음
   
   > % : 0글자 이상
   ex) 	비교대상 컬럼 LIKE '문자%' => 비교 대상의 컬럼 값이 '문자'로 시작되는 것 조회
   		비교대상 컬람 LIKE '%문자' => 비교 대상의 컬럼 값이 '문자'로 끝나는 것 조회
   		비교대상 칼럼 LIKE '%a문자% => 비교대상의 컬럼 값이 '문자'가 포함되어 있는 것을 조회
   	
   	_ : 1글자
   	ex) 비교대상 컬럼 LIKE '_문자' => 비교 대상의 칼럼값이 '문자' 앞에 무조건 한 글자가 올 경우 조회	
   		비교대상 컬럼 LIKE '__문자' => 비교 대상의 칼럼값이 '문자' 앞에 무조건 두 글자가 올 경우 조회
   		비교대상 컬럼 LIKE '_문자_' => 비교 대상의 칼럼값이 '문자' 앞과 뒤에 무조건 한 글자가 올 경우 조회
    
 */

-- 사원들 중에서 성씨가 전씨인 사원의 사원명, 급여, 입사일 조회
select EMP_NAME, SALARY, HIRE_DATE
from EMPLOYEE
where emp_name like '김%';

-- 사언들 이름 중에 '하'란 글자가 포함되어 있는 사원의 사번, 사원명, 전화번호 조회
select EMP_ID , EMP_NAME, PHONE
from employee
where EMP_NAME like '%하%';

-- 사원들 중 이름의 가운데에 '하'가 포함되어 있는 사원의 사번, 사원명,이메일 조회
select EMP_ID, EMP_NAME, EMAIL
from employee
where EMP_NAME like '_하_';

-- 전화번호 3번째 자리가 1인 사원의 사번, 사원명, 전화번호, 이메일 조회
select emp_id, emp_name, phone, email
from employee
where phone like '__1%';

-- 이메일 중 _(언더바) 앞에 글자가 3글자인 사원들의 사번 , 이름, 이메일 조회
select EMP_ID, EMP_NAME, EMAIL
from EMPLOYEE
where EMAIL like '____%';
-- 와일드카드로 사용되는 문자와 칼럼값에 들어있는 문자가 동일하기 때문에 조회가 안 됨
-- >> 어떤 것이 와일드카드이고 데이터값ㅇㄴ지 구분해줘야 함
--	>> 데이터값으로 취급하고자 하는 값 앞에 나만의 와일드카드(아무거나:숫자, 문자, 특수기호)를 넣어줌
--    나만의 와이드카드를 ESCAPE에 등록

-- 이메일 중 _(언더바) 앞에 글자가 3글자인 사원들의 사번 , 이름, 이메일 조회
select EMP_ID, EMP_NAME, EMAIL
from EMPLOYEE
where EMAIL like '___#_%' escape '#';

-- 위의 사원을 제외한 사원들 조회
select EMP_ID, EMP_NAME, EMAIL
from EMPLOYEE
where not EMAIL like '___#_%' escape '#';

-------------------- 실습문제 -----------------------
-- 1. EMPLOYEE에서 이름이 '연'으로 끝나는 사원들의 사번, 사원명, 입사일 조회
select EMP_ID, EMP_NAME, HIRE_DATE
from EMPLOYEE
where EMP_NAME like '%연';

-- 2. EMPLOYEE에서 전화번호 처음 3자리가 010이 아닌 사원들의 사원명, 전화번호 조회
select EMP_NAME, PHONE
from EMPLOYEE
where not PHONE like '010%';

-- 3. EMPLOYEE에서 이름에 '하'가 포함되어 있고 급여가 240만원 이상인 사원의 사번, 사원명, 급여 조회
select EMP_ID, EMP_NAME, SALARY
from employee
where EMP_NAME like '%하%' and SALARY >= 2400000;

-- 4. department에서 해외영업부인 부서들의 부서코드, 부서명 조회
select dept_id, dept_title
from department
where DEPT_TITLE like '해외영업%';
-------------------------------------------------------------
/*
	<IS NULL / IS NOT NULL>
	컬럼값에 NULL이 있을 경우 NULL값 비교에 이용하는 연산자
 */
-- employee 에서 보너스를 받지 않는 사원들의 사번, 이름, 급여, 보너스 조회
select EMP_ID, EMP_NAME, SALARY, BONUS
from EMPLOYEE
where BONUS is null;

-- employee에서 보너스를 받는 사원의 사번, 이름, 급여, 보너스 조회
select EMP_ID, EMP_NAME, SALARY, BONUS
from EMPLOYEE
where BONUS is not null;

-- EMPLOYEE에서 사수가 없는 사원의 사원명 부서코드 조회
select EMP_NAME, DEPT_CODE, MANAGER_ID
from EMPLOYEE
where MANAGER_ID is null;

--EMPLOYEE에서 부서배치를 받지 않았지만 보너스는 받는 사원들의 이름, 보너스, 부서코드 조회
select EMP_NAME, BONUS, DEPT_CODE
from EMPLOYEE
where DEPT_CODE is null and BONUS is not null;

------------------------------------------------------------------------
/*
  <IN / NOT IN>
  IN : 컬럼값이 내가 제시한 목록중에 일치하는 값이 있는것만 조회
  NOT IN : 컬럼값이 내가 제시한 목록중에 일치하는 값을 제외한 나머지 조회
  
  [표현법]
  비교대상 칼럼 IN ('값1','값2','값3'...)
 */

-- EMPLOYEE에서 부서코드가 D6이거나 D8이거나 D5인 사원의 이름, 부서코드, 급여 조회
select EMP_NAME, DEPT_CODE, SALARY
from EMPLOYEE
where DEPT_CODE in ('D6','D8','D5');

-- EMPLOYEE에서 부서코드가 D6이거나 D8이거나 D5이 아닌 사원의 이름, 부서코드, 급여 조회
select EMP_NAME, DEPT_CODE, SALARY
from EMPLOYEE
where DEPT_CODE not in ('D6','D8','D5');

-------------------------------------------------------------------------
/*
 	<연산자 우선순위>
 	1. () 
 	2. 산술 연산자
 	3. 연결 연산자
 	4. 비교 연산자
 	5. IS NULL / LIKE '패턴' / IN
 	6.BETWEEN AND
 	7. NOT(논리연산자)
 	8. AND(논리연산자)
 	9. OR(논리연산자)
 	
 * */

-- 직급 코드가 J7이거나 J2인 사원들 중 급여가 200만원 이상인 사언들의 모든 컬럼 조회
select*
from employee
where (JOB_CODE = 'J7' or JOB_CODE='J2') and SALARY >= 2000000;


-------------------------- 실습문제------------------------
-- 1. 사수가 없고 부서배치도 받지 않은 사원들의 사원명, 사수사번, 부서코드 조회
select EMP_NAME, MANAGER_ID, DEPT_CODE
from employee
where MANAGER_ID is null and DEPT_CODE is null;

-- 2. 연봉(보너스포함X)이 3000만원 이상이고 보너스를 받지 않은 사원들의 
--		사번, 사원명, 연봉, 보너스 조회
select EMP_ID, EMP_NAME, SALARY*12 as 연봉, BONUS
from EMPLOYEE
where SALARY*12 >=30000000 and BONUS is null;

-- 3. 입사일이 1995-01-01 이상이고 부서배치를 받은 사원들의 
--		사번, 사원명, 입사일, 부서코드 조회
select EMP_ID, EMP_NAME, HIRE_DATE, DEPT_CODE
from EMPLOYEE
where HIRE_DATE>='1995-01-01' and DEPT_CODE is not null;
-- 4. 급여가 200만원 이상 500만원 이하고 입사일이 2001-01-01 이상이고 
--		보너스를 받지 않는 사원들의 사번, 사원명, 급여, 입사일, 보너스 조회
select EMP_ID, EMP_NAME, SALARY, HIRE_DATE, BONUS
from EMPLOYEE
where SALARY between 2000000 and 5000000 and HIRE_DATE >= '2001-01-01' and BONUS is null;
-- 5. 보너스포함 연봉이 NULL이 아니고 이름에 '하'가 포함되어 있는 사원들의 
--		사번, 사원명, 급여, 보너스포함연봉 조회 (별칭부여)
select EMP_ID, EMP_NAME, SALARY, SALARY*BONUS + SALARY*12 as "연봉(보너스 포함)"
from EMPLOYEE
where SALARY*BONUS + SALARY*12 is not null and EMP_NAME like '%하%';

---------------------------------------------------------------------------
/*<ORDER BY절>
  SELECT문 가장 마지막 줄에 작성. 실행 순서도 가장 마지막
  
  [표현법]
  SELECT 조회할 컬럼, 컬럼....
  FROM 테이블명
  WHERE 조건식
  ORDER BY 정렬 기준의 컬럼명 | 별칭 | 컬럼 순서 [ASC | DESC] [NULLS FIRST | NULLS LAST]
  
  -ASC : 오름차순 정렬 (생략시 기본값)
  -DESC : 내림차순 정렬
  
  -NULLS FIRST : NULL데이터를 맨 앞에 배치(생략시 DESC 기본값)
  -NULLS LAST : NULL데이터를 맨 끝에 배치(생략시 ASC 기본값)
 */

select *
from EMPLOYEE
--order by BONUS nulls first;
--order by BONUS desc;
order by BONUS desc, SALARY; -- 기준 정렬 여러개 사용 가능

-- 전 사원의 사원명, 연봉 조회.(연봉의 내림차순 정렬)

select EMP_NAME, SALARY*12 as 연봉
from EMPLOYEE
--order by 연봉 DESC;
order by 2 desc;
------------------------------- 종합 문제 ----------------------------------
-- 1. JOB테이블에서 모든 정보 조회
select *
from JOB;

-- 2. JOB 테이블에서 직급 이름 조회
select JOB_NAME
from JOB;

-- 3. DEPARTMENT 테이블에서 모든 정보 조회
select *
from DEPARTMENT;

-- 4. EMPLOYEE테이블의 직원명, 이메일, 전화번호, 고용일 조회
select EMP_NAME, EMAIL, PHONE, HIRE_DATE
from EMPLOYEE;

-- 5. EMPLOYEE테이블의 고용일, 사원 이름, 월급 조회
select HIRE_DATE, EMP_NAME, SALARY
from EMPLOYEE;

-- 6. EMPLOYEE테이블에서 이름, 연봉, 총수령액(보너스포함), 실수령액(총수령액 - (연봉*세금 3%)) 조회
select EMP_NAME, SALARY*12 as 연봉, BONUS*SALARY + SALARY*12 as 총수령액, (BONUS*SALARY + SALARY*12)-(SALARY*12)*0.03 as 실수령액
from EMPLOYEE;

-- 7. EMPLOYEE테이블에서 JOB_CODE가 J1인 사원의 이름, 월급, 고용일, 연락처 조회
select EMP_NAME, SALARY, HIRE_DATE, PHONE
from EMPLOYEE
where JOB_CODE = 'J1';
-- 8. EMPLOYEE테이블에서 실수령액이 5천만원 이상인 사원의 이름, 월급, 실수령액, 고용일 조회
select EMP_NAME, SALARY, (SALARY*12+BONUS*SALARY)-(SALARY*12)*0.03 as 실수령액, HIRE_DATE
from EMPLOYEE
where (SALARY*12+BONUS*SALARY)-(SALARY*12)*0.03 >= 50000000;
-- 9. EMPLOYEE테이블에 월급이 4000000이상이고 JOB_CODE가 J2인 사원의 전체 내용 조회
select *
from EMPLOYEE
where SALARY >=4000000 and JOB_CODE = 'J2';

-- 10. EMPLOYEE테이블에 DEPT_CODE가 D9이거나 D5인 사원 중 고용일이 02년 1월 1일보다 빠른 사원의 이름, 부서코드, 고용일 조회
select EMP_NAME, DEPT_CODE, HIRE_DATE
from EMPLOYEE
where DEPT_CODE in ('D9','D5') and HIRE_DATE< '2002-01-01';
-- 11. EMPLOYEE테이블에 고용일이 1990-01-01 ~ 2001-01-01인 사원의 전체 내용을 조회
select*
from EMPLOYEE
where HIRE_DATE between '1990-01-01' and '2001-01-01';
-- 12. EMPLOYEE테이블에서 이름 끝이 '연'으로 끝나는 사원의 이름 조회
select EMP_NAME
from EMPLOYEE
where EMP_NAME like '%연';
-- 13. EMPLOYEE테이블에서 전화번호 처음 3자리가 010이 아닌 사원의 이름, 전화번호를 조회
select EMP_NAME, PHONE
from EMPLOYEE
where not PHONE like '010%';
-- 14. EMPLOYEE테이블에서 메일주소 '_'의 앞이 4자이면서 DEPT_CODE가 D9 또는 D6이고 
-- 고용일이 1990-01-01 ~ 2000-12-01이고, 급여가 270만 이상인 사원의 전체를 조회
select*
from EMPLOYEE
where EMAIL like '____#_%' escape '#'
and DEPT_CODE in ('D9','D6') and HIRE_DATE between '1990-01-01' and '2000-12-01'
and SALARY >= 2700000;
