function setElementGlobal(hypeDocument) {
  function setElement(element_id, content) {
      var element = hypeDocument.getElementById(element_id)
      if(element) {
        element.innerHTML=content;
      }
  }

  setElement('p1-name', tianhua2020.p1_name);
  setElement('p1-workbirthday', tianhua2020.p1_workbirthday);

  setElement('p3-workrate', tianhua2020.p3_workrate);

  setElement('p4-busymonth', tianhua2020.p4_busymonth);
  setElement('p4-busy-week', tianhua2020.p4_busy_week);
  setElement('p4-workcom', tianhua2020.p4_workcom);

  setElement('p6-prjno', tianhua2020.p6_prjno);
  setElement('p6-totalarea', tianhua2020.p6_totalarea);
  setElement('p6-city', tianhua2020.p6_city);
  setElement('p6-hometown', tianhua2020.p6_hometown);

  setElement('p7-coworkprj', tianhua2020.p7_coworkprj);
  setElement('p7-customer', tianhua2020.p7_customer);

  setElement('p8-design-prj', tianhua2020.p8_design_prj);
  setElement('p8-design-award', tianhua2020.p8_design_award);

  setElement('p9-design-meeting-times', tianhua2020.p9_design_meeting_times);
  setElement('p9-design-meeting-score', tianhua2020.p9_design_meeting_score);
  setElement('p9-design-meeting-rate', tianhua2020.p9_design_meeting_rate);

  setElement('p10-teacher-level', tianhua2020.p10_teacher_level);
  setElement('p10-course-number', tianhua2020.p10_course_number);

  setElement('p11-finish-course', tianhua2020.p11_finish_course);
  setElement('p11-study-time', tianhua2020.p11_study_time);
  setElement('p11-study-point', tianhua2020.p11_study_point);
  setElement('p11-study-rate', tianhua2020.p11_study_rate);
  setElement('p11-study-award', tianhua2020.p11_study_award);

  setElement('p12-km-login-date', tianhua2020.p12_km_login_date);
  setElement('p12-km-login-times', tianhua2020.p12_km_login_times);
  setElement('p12-km-pop-part', tianhua2020.p12_km_pop_part);

  setElement('p13-new-title', tianhua2020.p13_new_title);

  setElement('p14-coparter-org-dept', tianhua2020.p14_coparter_org_dept);
  setElement('p14-coparter', tianhua2020.p14_coparter);
  setElement('p14-coprj', tianhua2020.p14_coprj);
  setElement('p14-cohours', tianhua2020.p14_cohours);

  setElement('p15-7777', tianhua2020.p15_7777);
  setElement('p15-reimburse', tianhua2020.p15_reimburse);

  setElement('p16-teacher', tianhua2020.p16_teacher);
  setElement('p16-adviser', tianhua2020.p16_adviser);

  setElement('p17-oa-login', tianhua2020.p17_oa_login);
  setElement('p17-oa-pv', tianhua2020.p17_oa_pv);
}
