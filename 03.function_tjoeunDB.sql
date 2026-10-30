/*
 	<함수 FUNCTION>
 	전달된 컬럼값을 읽어들여 함수를 실행한 결과 반환
 	
 	- 단일행 함수 : N개의 값을 읽어들여서 N개의 결과값 반환 (매 행마다 함수 실행)
 	- 그룹 함수 : N개의 값을 읽어들여서 1개의 결과값 반환 (그룹별로 함수 실행)
 	
 	>> SELECT절에 단행 함수와 그룹함수를 함꼐 사용할 수 없음
 	>> 함수식을 기술할 수 있는 위치 : SELECT절, WHERE절, ORDER BY절, HAVING절
 */

-- 단일행 함수
--=====================================================
-- <문자 처리 함수>
-- ====================================================
/*
   LENGTH / OCTET_LENGTH => INTEGER로 반환
   
   LENGTH(컬럼명 | '문자열') : 해당 글자 수 반환
   OCTET_LENGTH(컬럼명 | '문자열) : 해당 문자열의 BYTE수 반환
   - 한글 : 한 글자당 3byte / 영문, 숫자, 공백 : 한 글자당 1byte
 */
select LENGTH('데이터베이스'), OCTET_LENGTH('데이터베이스');

select LENGTH('postgreSQL'), OCTET_LENGTH('postgreSQL');

select EMP_NAME, LENGTH(EMP_NAME), OCTET_LENGTH(EMP_NAME)
	, EMAIL, LENGTH(EMAIL), OCTET_LENGTH(EMAIL)
from EMPLOYEE;


---------------------------------------------------------

/*
	LEFT / RIGHT('문자열', 글자수) : 왼쪽/오른쪽 끝에서부터 지정한 개수만큼 문자열 반환
	> 글자수에 음수를 넣으면 맨 뒤/앞의 글자수만큼 제외하고 나머지 전부
 */
select LEFT('databasepostgreSQL', 4);
select RIGHT('databasepostgreSQL', 3);
select RIGHT('서울특별시', 3);

select LEFT('DATABASESQL', -3); -- 맨 뒤의 글자 3개를 제외하고
select RIGHT('DATABASEPOSTGRESQL',-8); -- 맨 앞의 글자 8개를 제외하고

select RIGHT('DATA', 100);
select LEFT('DATA', 0); -- 빈 문자열 반환

------------------------------------------------------------------
/*
 POSITION / STRPOS : 문자열로부터 특정 문자의 시작위치(INDEX)를 찾아서 반환(1부터 시작, 없으면 0)
*/

select POSITION('A' in 'DATABASE');
select STRPOS('DATABASE', 'A');
select POSITION('A' in REVERSE('DATABASE')); -- 결과 : 3. REVERSE의 경우 문자열을 뒤집어서 셈

select EMAIL,
		POSITION('_' in EMAIL) as "_위치",
		POSITION('@' in EMAIL) as "@위치"
from EMPLOYEE;

---------------------------------------------------------------------------
/*
 * SUBSTR / SUBSTRING : 문자열에서 특정 문자열을 추출 

  - SUBSTR('문자열', POSITION, [LENGTH])
  	> POSITION : 문자열을 추출할 시작위치 INDEX
  	> LENGTH : 추출할 문자 개수(생략시 맨 끝까지 추출)
  - SUBSTRING('문자열' from POSITION [for LENGTH])
 */

select SUBSTR('DATABASESQL', 5);
select SUBSTRING('DATABASESQL' from 5);

select SUBSTR('DATABASESQL', 5, 4);
select SUBSTRING('DATABASESQL' from 5 for 4);

select SUBSTR('DATABASESQL', 3, 6);
select SUBSTRING('DATABASESQL' from 3 for 6);

-- EMPLOYEE테이블에서 주민번호에 성별만 추출하여 주민번호, 사원명, 성별 조회
select EMP_NO, EMP_NAME, SUBSTR(EMP_NO, 8,1) as 성별
from EMPLOYEE;

-- EMPLOYEE테이블에서 여자 사원들만 사번, 사원명, 성별 조회
select EMP_ID , EMP_NAME, SUBSTR(EMP_NO, 8, 1) as 성별
from EMPLOYEE
where SUBSTR(EMP_NO, 8, 1) in ('2','4');

-- EMPLOYEE테이블에서 남자 사원들만 사번, 사원명, 성별 조회
select EMP_ID , EMP_NAME, SUBSTR(EMP_NO, 8, 1) as 성별
from EMPLOYEE
where SUBSTR(EMP_NO, 8, 1) in ('1','3');

-- EMPLOYEE테이블에서 EMAIL의 아이디만 추출하여 사원명, 이메일, 아이디 조회
select EMP_NAME, EMAIL, SUBSTR(EMAIL, 1, position('@' in EMAIL)-1) as 아이디
--select EMP_NAME, EMAIL, LEFT(EMAIL, -11)
from EMPLOYEE;

------------------------------------------------------------------------------
/*
   LPAD / RPAD : 문자열 조회할 때 길이를 맞춰 통일감 있게 조회하고자 할 때 
   
   LPAD/RPAD('문자열', 최종반환할 문자의 길이, [덧붙이고자하는 문자])
 */
-- 20길이에 맞춰 EMAIL을 우측정렬, 앞부분은 공백으로 채워서 출력
select EMP_NAME, LPAD(EMAIL, 25) -- 덧붙이고자하는 문자 생략시 기본값 공백
from EMPLOYEE;

select EMP_NAME, LPAD(EMAIL,25,'#')
from EMPLOYEE;

select EMP_NAME, RPAD(EMAIL, 25, '#')
from EMPLOYEE;

-- EMPLOYEE테이블에서 사번, 사원명, 주민번호 출력(주민번호는 123456-1******의 형식으로)
--select EMP_ID, EMP_NAME, RPAD(SUBSTR(EMP_NO,1,8),14,'*') as 주민번호
select EMP_ID, EMP_NAME, RPAD(left(EMP_NO, -6),14,'*') as 주민번호
from EMPLOYEE;

--------------------------------------------------------------------------
/*
   LTRIM / RTRIM : 문자열에서 특정 문자열 문자를 제거
   TRIM : 문자의 앞/뒤 양쪽에 ㅇㅆ는 특정 문자들을 제거한 나머지 반환
   
   LTRIM/RTRIM('문자열', [제거하고자 하는 문자]) -> 제거하고자 하는 문자 생략 가능. 생략시 공백 제거
   TRIM([LEDING|TRAILING|BOTH] 제거하고자 하는 문자 FROM '문자열') 
 */
select LTRIM('     TJOEUN      ')||'컴퓨터 아카데미';
select RTRIM('     TJOEUN      ')||'컴퓨터 아카데미';

select LTRIM('DATADATABASE', 'DATA');
select LTRIM('ACABCCBABBACAADADFG','ABC');
select LTRIM('34250fajog21490238','0123456789');

select RTRIM('34250fajog21490238','0123456789');

select TRIM('          TJOEUN            ')||'컴퓨터 아카데미'; --기본값 양쪽 제거

-- 방향 지정
select TRIM(leading 'A' from 'AAAADAGAIOGSGHSKLEJLKG');
select TRIM(trailing 'A' from 'AAADOGDDJOFSGDSKAAAA');
select TRIM(both 'A' from 'AAADOGDDJOFSGDSKAAAA');
select TRIM('A' from 'AAADOGDDJOFSGDSKAAAA');

-----------------------------------------------------------------------------
/*
   LOWER / UPPER / INITCAP : 문자열을 대소문자로 변환 및 단어의 앞글자만 대문자로 변환
   
   LOWER/UPPER/INITCAP('문자열') 
 */
select LOWER('DATABASE postgreSQL');
select UPPER('DATABASE postgerSQL');
select INITCAP('database postgreSQL');

--------------------------------------------------------------------------------
/*
  CONCAT : 문자열 두개를 하나로 합친 결과 반환
  
  CONCAT('문자열','문자열',...)
 */
select CONCAT('SQL','포스트그레');
select CONCAT('PostgreSQL','데이터베이스','204252535');

select 'SQL' || '포스트그레';

-------------------------------------------------------------------------------------
/*
  REPLACE : 기존 문자열을 새로운 문자열로 변경
  
  [표현법]
  REPLACE('문자열','기존 문자열', '바꿀 문자열')
 */
select EMP_NAME, EMAIL, REPLACE(EMAIL, 'google', 'naver')
from EMPLOYEE;

--=====================================================
-- <숫자 처리 함수>
-- ====================================================
/*
  ABS : 숫자의 절대값을 구해주는 함수
  
  ABS(NUMBER)
 */

select ABS(-10);
select ABS(-14.3295);

------------------------------------------------------------------------------------------------
/*
  MOD / % : 나머지 값 반환
 */
select MOD(10,3);
select 10%3; -- postgreSQL 에서만 사용

---------------------------------------------------------------------------------------------
/*
   ROUND :반올림 결과 반환
   
   [표현법]
   ROUND(NUMBER, [위치])
 */

select ROUND(1235.235);
select ROUND(12.34);

select ROUND(12.25362, 2);
select ROUND(124.32, 4);

select ROUND(1234.56, -2); -- 소수점을 기준으로 0. 소수점 아래는 +, 소수점 위는 -
select ROUND(1273.643, -2);

-------------------------------------------------------------------------------------------
/*
  CEIL : 올림한 결과 반환
  FLOOR : 내림한 결과 반환
 */
select CEIL(123.234);
select CEIL(-123.234);

select FLOOR(123.234);
select FLOOR(-123.234);


-------------------------------------------------------------------------------------------
/*
   TRUNC : 버림
   TRUNC(NUMBER,[위치])
 */
select TRUNC(123.789);
select TRUNC(123.789, 1);

select TRUNC(-123.789);
select TRUNC(125.456, -1);

--=====================================================
-- <날짜 처리 함수>
-- ====================================================
/*
  CURRENT_DATE() : 시스템의 오늘 날짜
  NOW() : 시스템 날짜와 시간
 */
select CURRENT_DATE;
select NOW();

select EMP_NAME, HIRE_DATE, CURRENT_DATE - HIRE_DATE as 근무일수
from EMPLOYEE;

------------------------------------------------------------------------
/*
  INTERVAL 'n MONTH' : 특정 날짜에 해당 숫자만큼 개월수를 더해 날짜를 리턴
*/

select CURRENT_DATE + interval '1 MONTH';
select (CURRENT_DATE + interval '1 MONTH')::DATE as 다음달;

-- EMPLOYEE에서 사원명, 입사일, 입사후 정직원이 된 날짜(6개월 후) 조회
select EMP_NAME, HIRE_DATE, (HIRE_DATE + interval '6 MONTH')::DATE "정직원이 된 날짜"
from EMPLOYEE;

---------------------------------------------------------------------------
/*
  EXTRACT : 특정날짜로부터 년|월|일 값을 추출하여 반환
  
  EXTRACT(YEAR FROM DATE) : 연도만 추출
  EXTRACT(MONTH FROM DATE) : 월만 추출
  EXTRACT(DAY FROM DATE) : 일만 추출 
 */

-- EMPLOYEE에서 사원명, 입사년도, 입사얼, 입사일 조회
select EMP_NAME
, (EXTRACT(year from HIRE_DATE))::TEXT as 입사년도
, EXTRACT(month from HIRE_DATE) as 입사월
, EXtRACT(day from HIRE_DATE) as 입사일
from EMPLOYEE;

--=====================================================
-- <형 변환 함수>
-- ====================================================
/*
   TO_CHAR : 숫자 또는 날짜를 문자로 변환
   - 특정 형식에 맞게 출력 가능
   
   TO_CHAR(숫자|날짜, [포맷])
 */

-- 숫자타입 => 문자타입
/*
   9 : 해당 자리의 숫자
   	- 값이 없을 경우 소수점 이상은 공백, 소수점 이하는 0 표시
   0 : 해당 자리의 숫자를 의미
   	- 값이 없을 경우 0으로 표시
   FM : 해당자리에 값이 없을 경우 자리 차지하지 않음
   
 */
select TO_CHAR(1234, '99999'), TO_CHAR(1234, '00000');
select TO_CHAR(123.45, '99999.9999'), TO_CHAR(123.45, '00000.0000');
select TO_CHAR(0.12, '9.99'), TO_CHAR(0.12, '0.00'); 

select '\' || TO_CHAR(1234, '99,999');

select EMP_NAME
, '\' || TO_CHAR(SALARY, '999,999,999')as 급여
, '\' || TO_CHAR(SALARY*12, '999,999,999') as 연봉
from EMPLOYEE;

select TO_CHAR(0.1000, '999990.999');

select TO_CHAR(123.456, 'FM99990.999')
	, TO_CHAR(1234.56, 'FM99990.999')
	, TO_CHAR(0.100, 'FM9990.999')
	, TO_CHAR(0.100, 'FM9999.999');


-- postgreSQL에서만 사용
-- FML : L(LOCAL의 설정에 따라 통화 기호를 나타냄)
select TO_CHAR(1234, 'FML999,999');

select EMP_NAME
,TO_CHAR(SALARY, 'FML999,999,999')as 급여
,TO_CHAR(SALARY*12, 'FML999,999,999') as 연봉
from EMPLOYEE;

-- 날짜타입 => 문자타입
select TO_CHAR(NOW(), 'YYYY') as "년도 4자리"
	, TO_CHAR(NOW(), 'YY') as "년도 2자리"
	, TO_CHAR(NOW(), 'MM') as 월
	, TO_CHAR(NOW(), 'DD') as 일
	, TO_CHAR(NOW(), 'DAY') as 요일 -- 대소문자 가림(대문자로 쓰면 대문자로, 소문자로 쓰면 소문자로 나옴)
	, TO_CHAR(NOW(), 'HH') as 시
	, TO_CHAR(NOW(), 'MI') as 분
	, TO_CHAR(NOW(), 'SS') as 초;

-- 시간
select TO_CHAR(NOW(), 'AM HH:MI:SS'); -- AM, PM 둘 중 뭘 써도 상관 없음
select TO_CHAR(NOW(), 'HH12:MI:SS'); -- AM, PM 없이 12시간제
select TO_CHAR(NOW(), 'HH24:MI:SS'); -- 24시간제. AM, PM 없이

-- 날짜
select TO_CHAR(NOW(), 'YYYY-MM-DD DAY');
select TO_CHAR(NOW(), 'YYYY"년" MM"월" DD"일" DAY');

-- EMPLOYEE에서 사원명, 입사일(형식: 25-10-28) 조회
select EMP_NAME, TO_CHAR(HIRE_DATE, 'YY-MM-DD') as 입사일
from EMPLOYEE;

-- EMPLOYEE에서 사원명, 입사년도(4자리), 입사월, 입사일 조회
select EMP_NAME
	, TO_CHAR(HIRE_DATE, 'YYYY') as 입사년도
	, TO_CHAR(HIRE_DATE, 'MM') as 입사월
	, TO_CHAR(HIRE_DATE, 'DD')as 입사일
from EMPLOYEE;

---------------------------------------------------------
/*
   TO_DATE : 문자열을 날짜로 변경
   > 숫자를 바로 넣는것은 허용하지 않음. 반드시 문자열로 넣어야 함
   
   TO_DATE('문자열','포맷')
 */
select TO_DATE('261028','YYMMDD');
select TO_DATE('261028 150821', 'YYMMDD HH24MISS');
 -- TO_DATE 함수의 특성상 시간 정보는 버려짐. 연월일만 출력
select TO_DATE(20261028::TEXT, 'YYYYMMDD');

-------------------------------------------------------
/*
   TO_TIMESTAMP() : 문자열로 표현된 날짜와 시간을 포맷으로 변환
   TO_TIMESTAMP('문자열','포맷')
 */

select TO_TIMESTAMP('2026-10-28 15:13:30', 'YYYY-MM-DD HH24:MI:SS');
select TO_TIMESTAMP('20261028151330', 'YYYYMMDDHH24MISS');

select TO_TIMESTAMP('2026-10-28 PM 03:14', 'YYYY-MM-DD AM HH:MI');

-- 문자타입 => 숫자타입
/*
   TO_NUMBER() : 문자열을 숫자로 변환
 */

select TO_NUMBER('012341234', '999999999');
select TO_NUMBER('1,000,000', '999,999,999') + TO_NUMBER('550000','999,999,999');

select '1000000'::INTEGER + '550000'::INT;

--=====================================================
-- <NULL 처리 함수>
-- ====================================================

/*
   COALESCE(컬럼, 해당 컬럼값이 NULL이떄 반환할 값)
 */

-- EMPLOYEE에서 사원영, 보너스(NULL이면 0으로 출력)
select EMP_NAME, COALESCE(BONUS, 0)
from EMPLOYEE;

-- EMPLOYEE에서 사원명, 보너스 포함 연봉 조회
select EMP_NAME, TO_CHAR((SALARY*(1+coalesce(BONUS,0)))*12, 'FML999,999,999,999') as 연봉
from EMPLOYEE;

-- EMPLOYEE 에서 사원명, 부서코드(NULL일 경우 '부서없음'), 입사일 조회
select EMP_NAME, COALESCE(DEPT_CODE, '부서없음') as 부서, HIRE_DATE
from EMPLOYEE;

--=====================================================
-- <선택 함수>
-- ====================================================
/*
   CASE WHEN THEN
   ...
   END
   
    ex) CASE WHEN 조건식1 THEN 결과값1 
    		WHEN 조건식2 THEN  결과값2
    		...
    		ELSE 결과값N
    	END
 */

-- EMPLOYEE 테이블에서 급여가 350만원 미만이면 '초급', 350만원 이상 500만원 미만이면 '중급', 500만원 이상이면 '고급'

select EMP_NAME, SALARY
		, case when SALARY >= 5000000 then '고급'
				when SALARY >=3500000 then '중급'
				else '초급'
		end as 급수
from EMPLOYEE;


--=====================================================
-- <그룹 함수>
-- ====================================================
/*
 	SUM(숫자타입의 컬럼) : 컬럼들의 총 합계를반환
 **/

-- EMPLOYEE 에서 전 사원의 총 급여의 합
select SUM(SALARY) as "급여의 합계" from EMPLOYEE;


-- EMPLOYEE에서 남자 사원의 급여의 합
select SUM(SALARY)
from EMPLOYEE
where SUBSTR(EMP_NO, 8, 1) in ('1','3');

-- EMPLOYEE에서 부서코드가 D5인 사원들의 연봉 총 합
select SUM(SALARY*12)
from EMPLOYEE
where DEPT_CODE = 'D5';

-- EMPLOYEE에서 부서코드가 D5인 사원들의 연봉(보너스 포함) 총 합
select TO_CHAR(SUM(SALARY*(1+coalesce(BONUS, 0))*12), 'FML999,999,999,999')
from EMPLOYEE
where DEPT_CODE = 'D5';


/*
   AVG(숫자타입의 컬럼) : 평균반환
 */

select AVG(SALARY) from EMPLOYEE;
select ROUND(AVG(SALARY),-1) from EMPLOYEE;

/*
   MIN / MAX (모든 타입의 컬럼) : 최솟값과 최댓값 
 */

select MIN(EMP_NAME), MIN(SALARY), MIN(HIRE_DATE) from EMPLOYEE;
select MAX(EMP_NAME), MAX(SALARY), MAX(HIRE_DATE) from EMPLOYEE;

/*
  COUNT(* | 컬럼 | DISTINCT 컬럼) 
  
  COUNT(*) : 조회된 결괴의 모든 행의 개수 반환
  COUNT(컬럼) : 컬럼 값이 NULL이 아닌 행의 개수 반환
  COUNT(DISTINCT 컬럼) : 중복을 제거한 행의 개수 반환
 */
-- EMPLOYEE의 전체 사원 수
select COUNT(*) from EMPLOYEE;

-- 보너스를 받는 사원의 수
select COUNT(BONUS) from EMPLOYEE;

-- 부서 배치를 받은 사원의 수
select COUNT(DEPT_CODE) from EMPLOYEE;

-- 중복을 제거한 부서의 수
select COUNT(distinct DEPT_CODE) from EMPLOYEE;

-- 여성 사원의 수
select COUNT(*)
from EMPLOYEE
where SUBSTR(EMP_NO, 8, 1) in ('2','4');


--=====================================================
-- <postgreSQL 에서의 형변환>
-- ====================================================

-- 숫자 자료형
::INT or ::INTEGER	--정수 4byte
::NUMERIC 			--소수(정수)
::REAL 				--실수 4byte

--문자 자료형
::TEXT				--길이 제한이 없는 문자열
::VARCHAR			--가변길이 문자열
::VARCHAR(n)		--가변길이이지만 최대 n글자
::CHAR(n)			--n길이만큼의 고정 길이

-- 날짜 시간
::DATE				--날짜만 표시
::TIME				--시간만 표시
::TIMESTAMP			--날짜와 시간 표시
::INTERVAL			--'1 MONTH'::INTERVAL 도 가능

-- 기타 자료형
::BOOLEAN			--참 / 거짓
::JSON				--json 자료형 '{"AGE" : 25}'::JSON



