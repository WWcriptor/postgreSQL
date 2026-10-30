-- 1. 춘 기술 대학교의 학과 이름과 계열을 표시하시오. 단, 출력 헤더는 "학과 명"과 "계열"으로 표시하도록 한다.
select DEPARTMENT_NAME as "학과 명", CATEGORY as 계열
from TB_DEPARTMENT;

-- 2. 학과의 학과 정원을 다음과 같은 형태로 화면에 출력한다.
/*
 학과별 정원
 -------------
 국어국문학과의 정원은 20명 입니다
 영어영문학과의 정원은 36명 입니다
 .
 .
 .
 */

select DEPARTMENT_NAME || '의 정원은 ' || CAPACITY || '명 입니다'
from TB_DEPARTMENT;

-- 3. 도서관에서 대출 도서 장기 연체자들을 찾아 이름을 게시학자 한다. 그 대상자들의 학번이 다음과 같을 때 대상자들을 찾는 적절한 SQL 구문을 작성하시오.
-- A513079, A513090, A513091, A513110, A513119
select STUDENT_NAME
from TB_STUDENT
where STUDENT_NO in ('A513079', 'A513090', 'A513091', 'A513110', 'A513119');
-- 4. 입학 정원이 20명 이상 30명 이하인 학과들의 학과 이름과 계열을 출력하시오.
select DEPARTMENT_NAME, CATEGORY
from TB_DEPARTMENT
where CAPACITY between 20 and 30;
-- 5. 춘 기술대학교는 총장을 제외하고 모든 교수들이 소속 학과를 가지고 있다.
--	  그럼 춘 기술대학교 총장의 이름을 알아낼 수 있는 SQL 문장을 작성하시오.
select PROFESSOR_NAME
from TB_PROFESSOR
where DEPARTMENT_NO is null;
-- 6. 혹시 전산상의 착오로 학과가 지정되어 있지 않은 학생이 있는지 확인하고자 한다. 어떠한 SQL문장을 사용하면 될 것인지 작성하시오.
select STUDENT_NAME, DEPARTMENT_NO
from TB_STUDENT
where DEPARTMENT_NO is null;
-- 7. 수강신청을 하려고 한다. 선수과목 여부를 확인해야 하는데, 선수과목이 존재하는 과목들은 어떤 과목인지 과목 번호를 조회해보시오.
select CLASS_NO
from TB_CLASS
where PREATTENDING_CLASS_NO is not null;
-- 8. 춘 대학에는 어떤 계열(CATEGORY)들이 있는지 조회해보시오.
select distinct CATEGORY
from TB_DEPARTMENT;

-- 9. 02학번 전주 거주자들의 모임을 만들려고 한다. 휴학한 사람들은 제외한 재학중인 학생들의 학번, 이름 주민번호를 출력하는 구문을 작성하지오.
select STUDENT_NO, STUDENT_NAME, STUDENT_SSN
from tb_student
where not ABSENCE_YN = 'Y' and STUDENT_ADDRESS like '%전주%' 
and ENTRANCE_DATE between '2002-01-01' and '2002-12-31'; 

----------------------- 함수 -----------------------------
-- 1. 영어영문학과(학과코드002) 학생들의 학번과 이름 입학년도를 입학년도가 빠른 순으로 표시하는 SQL 문장을 작성
-- (단, 헤더는 '학번', '이름', '입학년도'가 표시되도록 한다)
select STUDENT_NO as 학번, STUDENT_NAME as 이름, EXTRACT(year from ENTRANCE_DATE) as 입학년도
from TB_STUDENT
where DEPARTMENT_NO = '002'
order by 입학년도;

--2. 춘 기술 대학교의 교수 중 이름이 세글자가 아닌 교수가 한 명 있다고 한다.
-- 그 교수의 이름과 주민번호를 화면에 출력하는 SQL 문장을 작성해보자.
select PROFESSOR_NAME, PROFESSOR_SSN
from TB_PROFESSOR
where LENGTH(PROFESSOR_NAME) != 3;

--3. 춘 기술 대학교의 남자 교수들의 이름과 나이를 출력하는 SQL 문장을 작성하시오.
-- 단, 이떄 나이가 적은 사람에서 많은 사람 순으로 화면에 출력되도록 만드시오.
-- (단, 교수 중 2000년 이후 출생자는 없으며 출력헤더는 "교수 이름", "나이"로 한다. 나이는 '만'으로 계산한다.)
select PROFESSOR_NAME as "교수 이름"
, extract(year from AGE(CURRENT_DATE, TO_DATE('19'||SUBSTR(PROFESSOR_SSN,1,6),'YYYYMMDD'))) as 나이
from TB_PROFESSOR;

-- 4. 교수들의 이름 중 성을 제외한 이름만 출력하는 SQL 문장을 작성하시오. 출력 헤더는"이름"이 직히도록 한다.
-- (성이 2자인 경우는 교수는 없다고 가정하시오)
select RIGHT(PROFESSOR_NAME, -1)as 이름
from TB_PROFESSOR;

-- 5. 춘 기술대학교의 재수생 입학자를 구하려고 한다. 어떻게 찾아낼 것인가? 이때, 19살에 입학하면 재수를 하지 않은 것으로 간주한다.
select *
from TB_STUDENT
where extract(year from ENTRANCE_DATE)- EXTRACT(year from TO_DATE(SUBSTR(STUDENT_SSN,1,6), 'YYMMDD')) >= 20;

-- 6. 2020년 크리스마스는 무슨 요일인가?
select TO_CHAR(TO_DATE('2020/12/25', 'YYYY/MM/DD'),'DAY');

-- 7. TO_DATE('99/10/11', 'YY/MM/DD), TO_DATE('49/10/11','YY/MM/DD')은 각각 몇 년 몇 월 몇 일을 의미할까?
-- 또 TO_DATE('99/10/11', 'RR/MM/DD), TO_DATE('49/10/11', 'RR/MM/DD)은 각각 몇 년 몇 월 몇 일을 의미할까? 
select TO_CHAR(TO_DATE('99/10/11', 'YY/MM/DD'),'YYYY년 MM월 DD일')
,TO_CHAR(TO_DATE('49/10/11', 'YY/MM/DD'),'YYYY년 MM월 DD일')
,TO_CHAR(TO_DATE('99/10/11', 'RR/MM/DD'),'YYYY년 MM월 DD일')
,TO_CHAR(TO_DATE('49/10/11', 'RR/MM/DD'),'YYYY년 MM월 DD일');

-- 8. 춘 기술대학교의 2000년도 이후 입학자들은 학번이 A로 시작하게 되어있다. 2000년도 이전 학번을 받은 학생들의 학번과 이름을 보여주는 SQL 문장을 작성하시오.
select STUDENT_NO, STUDENT_NAME
from TB_STUDENT
where ENTRANCE_DATE<'2000-01-01';
-- 9. 학번이 A517178인 한아름 학생의 학점 총 평점을 구하는 SQL문을 작성하시오
-- 단, 이때 출력 화면의 헤더는 "평점"이라고 찍히게 하고, 점수는 반올림하여 소수점 이하 한 자리까지만 표시한다.
select ROUND(AVG(POINT),1) as 평점
from TB_GRADE
where STUDENT_NO = 'A517178';

-- 10. 학과별 학생수를 구하여 "학과번호", "학생수(명)"의 형태로 헤더를 만들어 결과값이 출력되도록 하시오


-- 11. 지도 교수를 배정받지 못한 학생의 수는 몇 명 정도 되는 지 알아내는 SQL문을 작성하시오
select COUNT(*)
from TB_STUDENT
where COACH_PROFESSOR_NO is null;
-- 12. 학번이 A112113인 김고운 학생의 년도 별 평점을 구하는 SQL문을 작성하시오. 단, 이때 출력 화면의 헤더는 "년도", "년도 별 평점"이라고 찍히게 하고,
-- 점수는 반올림하여 소수점 이하 한 자리까지만 표시한다.


-- 13. 학과 별 휴학생 수를 파악하고자 한다. 학과 번호와 휴학생 수를 표시하는 SQL 문장을 작성하시오.






