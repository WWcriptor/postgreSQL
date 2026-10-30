------------------------------- 종합 문제 ----------------------------------
-- 1. EMPLOYEE테이블에서 JOB 테이블의 모든 정보 조회
select JOB.*
from EMPLOYEE
join JOB using(JOB_CODE);

-- 2. EMPLOYEE테이블에서 JOB 테이블의 직급 이름 조회
select JOB_NAME
from EMPLOYEE
join JOB using(JOB_CODE);

-- 3. EMPLOYEE테이블에서 DEPARTMENT 테이블의 모든 정보 조회
select DEPARTMENT.*
from EMPLOYEE
join DEPARTMENT on (DEPT_CODE = DEPT_ID);
-- 4. EMPLOYEE테이블의 직원명, 이메일, 전화번호, 고용일 조회
select EMP_NAME, EMAIL, PHONE, HIRE_DATE
from EMPLOYEE;

-- 5. EMPLOYEE테이블의 고용일, 사원 이름, 월급 조회
select HIRE_DATE, EMP_NAME, SALARY
from EMPLOYEE;

-- 6. EMPLOYEE테이블에서 이름, 연봉, 총수령액(보너스포함), 실수령액(총수령액 - (연봉*세금 3%)) 조회
select EMP_NAME
, SALARY*12 as 연봉
, SALARY*(1+coalesce(BONUS, 0))*12 as 총수령액
, (SALARY*(1+coalesce(BONUS, 0))*12)*0.97 as 실수령액
from EMPLOYEE;
-- 7. EMPLOYEE테이블에서 DEPT_CODE가 D5인 사원의 이름, 부서코드, 월급, 고용일, 연락처 조회
select EMP_NAME, DEPT_CODE, SALARY, HIRE_DATE, PHONE
from EMPLOYEE
where DEPT_CODE ='D5';
-- 8. EMPLOYEE테이블에서 실수령액(6번 참고)이 5천만원 이상인 사원의 이름, 월급, 실수령액, 고용일 조회
select EMP_NAME, SALARY, (SALARY*(1+coalesce(BONUS, 0))*12)*0.97 as 실수령액, HIRE_DATE
from EMPLOYEE
where (SALARY*(1+coalesce(BONUS, 0))*12)*0.97 >= 50000000;

-- 9. EMPLOYEE테이블에 월급이 4000000이상이고 JOB_CODE가 J2인 사원의 전체 내용 조회
select *
from EMPLOYEE
where SALARY >= 4000000 and JOB_CODE = 'J2';
-- 10. EMPLOYEE테이블에 DEPT_CODE가 D9이거나 D5인 사원 중 
--     고용일이 02년 1월 1일보다 빠른 사원의 이름, 부서코드, 고용일 조회
select EMP_NAME, DEPT_CODE, HIRE_DATE
from EMPLOYEE
where DEPT_CODE in ('D9', 'D5') and HIRE_DATE < '2002-01-01';
-- 11. EMPLOYEE테이블에 고용일이 90/01/01 ~ 01/01/01인 사원의 전체 내용을 조회
select *
from EMPLOYEE
where HIRE_DATE between '1990-01-01' and '2001-01-01';
-- 12. EMPLOYEE테이블에서 이름 끝이 '연'으로 끝나는 사원의 이름 조회
select EMP_NAME
from EMPLOYEE
where EMP_NAME like '__연';
-- 13. EMPLOYEE테이블에서 전화번호 처음 3자리가 010이 아닌 사원의 이름, 전화번호를 조회
select EMP_NAME, PHONE
from EMPLOYEE
where not PHONE like '010%';
-- 14. EMPLOYEE테이블에서 메일주소 '_'의 앞이 4자이면서 DEPT_CODE가 D9 또는 D6이고 
--     고용일이 90/01/01 ~ 00/12/01이고, 급여가 270만 이상인 사원의 전체를 조회
select *
from employee
where EMAIL like '____#_%' escape '#' and DEPT_CODE in ('D9', 'D6') and HIRE_DATE between '1990-01-01' and '2000-12-01' and SALARY >= 2700000;