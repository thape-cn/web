function submitFormButton(hypeDocument) {
  var to_who_name = hypeDocument.getElementById('to_who_name').value;
  var message = hypeDocument.getElementById('message').value;
  console.log("to_who_name: ", to_who_name, "message", message, "clerk code", tianhua2020.clerk_code);
  Rails.ajax({
    url: "/tianhua2020s.json",
    type: "POST",
    data: `clerk_code=${tianhua2020.clerk_code}&to_who_name=${encodeURIComponent(to_who_name)}&message=${encodeURIComponent(message)}`,
    success: function(data) {
      tianhua2020.flag_issued=true;
      console.log(data);
    }
  });
  hypeDocument.startTimelineNamed('Sendout', hypeDocument.kDirectionForward)
}

function showOrSkipNextSceneGlobal(hypeDocument) {
  var currentScene = hypeDocument.currentSceneName();
  switch (currentScene) {
      case '工龄页':
        hypeDocument.showSceneNamed('工时页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
        break;
      case '工时页':
        if (tianhua2020.p3_workrate) {
          hypeDocument.showSceneNamed('忙碌程度页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
        } else if (tianhua2020.p4_busymonth && tianhua2020.p4_busy_week) {
          hypeDocument.showSceneNamed('忙碌月周页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
        } else if (tianhua2020.p4_workcom) {
          hypeDocument.showSceneNamed('二线忙碌月页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
        } else if (tianhua2020.p6_city && tianhua2020.p6_hometown) {
          hypeDocument.showSceneNamed('参与多个项目页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
        } else if (tianhua2020.p6_prjno && tianhua2020.p6_totalarea && tianhua2020.p6_hometown) {
          hypeDocument.showSceneNamed('参与项目单城页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);  
        } else if (tianhua2020.p7_coworkprj && tianhua2020.p7_customer) {
          hypeDocument.showSceneNamed('参与项目详情页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);   
        } else if (tianhua2020.p8_design_prj && tianhua2020.p8_design_award) {
          hypeDocument.showSceneNamed('设计大奖页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);   
        } else if (tianhua2020.p9_design_meeting_times && tianhua2020.p9_design_meeting_score && tianhua2020.p9_design_meeting_rate) {
          hypeDocument.showSceneNamed('设计例会页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);   
        } else if (tianhua2020.p10_teacher_level && tianhua2020.p10_course_number) {
          hypeDocument.showSceneNamed('天华讲师页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);   
        } else if (tianhua2020.p11_finish_course && tianhua2020.p11_study_time && tianhua2020.p11_study_point && tianhua2020.p11_study_rate) {
          hypeDocument.showSceneNamed('天华学习页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);   
        } else {
          hypeDocument.showSceneNamed('逃学天华页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);   
        }
        break;
      case '忙碌程度页':
        if(tianhua2020.p4_busymonth && tianhua2020.p4_busy_week) {
          hypeDocument.showSceneNamed('忙碌月周页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
        } else if (tianhua2020.p4_workcom) {
          hypeDocument.showSceneNamed('二线忙碌月页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
        } else if (tianhua2020.p6_city && tianhua2020.p6_hometown) {
          hypeDocument.showSceneNamed('参与多个项目页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
        } else if (tianhua2020.p6_prjno && tianhua2020.p6_totalarea && tianhua2020.p6_hometown) {
          hypeDocument.showSceneNamed('参与项目单城页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);  
        } else if (tianhua2020.p7_coworkprj && tianhua2020.p7_customer) {
          hypeDocument.showSceneNamed('参与项目详情页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);   
        } else if (tianhua2020.p8_design_prj && tianhua2020.p8_design_award) {
          hypeDocument.showSceneNamed('设计大奖页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);   
        } else if (tianhua2020.p9_design_meeting_times && tianhua2020.p9_design_meeting_score && tianhua2020.p9_design_meeting_rate) {
          hypeDocument.showSceneNamed('设计例会页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);   
        } else if (tianhua2020.p10_teacher_level && tianhua2020.p10_course_number) {
          hypeDocument.showSceneNamed('天华讲师页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);   
        } else if (tianhua2020.p11_finish_course && tianhua2020.p11_study_time && tianhua2020.p11_study_point && tianhua2020.p11_study_rate) {
          hypeDocument.showSceneNamed('天华学习页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);   
        } else {
          hypeDocument.showSceneNamed('逃学天华页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);   
        }
        break;
      case '忙碌月周页':
        if(tianhua2020.p4_workcom) {
          hypeDocument.showSceneNamed('二线忙碌月页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
        } else if (tianhua2020.p6_city && tianhua2020.p6_hometown) {
          hypeDocument.showSceneNamed('参与多个项目页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
        } else if (tianhua2020.p6_prjno && tianhua2020.p6_totalarea && tianhua2020.p6_hometown) {
          hypeDocument.showSceneNamed('参与项目单城页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);  
        } else if (tianhua2020.p7_coworkprj && tianhua2020.p7_customer) {
          hypeDocument.showSceneNamed('参与项目详情页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);   
        } else if (tianhua2020.p8_design_prj && tianhua2020.p8_design_award) {
          hypeDocument.showSceneNamed('设计大奖页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);   
        } else if (tianhua2020.p9_design_meeting_times && tianhua2020.p9_design_meeting_score && tianhua2020.p9_design_meeting_rate) {
          hypeDocument.showSceneNamed('设计例会页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);   
        } else if (tianhua2020.p10_teacher_level && tianhua2020.p10_course_number) {
          hypeDocument.showSceneNamed('天华讲师页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);   
        } else if (tianhua2020.p11_finish_course && tianhua2020.p11_study_time && tianhua2020.p11_study_point && tianhua2020.p11_study_rate) {
          hypeDocument.showSceneNamed('天华学习页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);   
        } else {
          hypeDocument.showSceneNamed('逃学天华页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);   
        }
        break;
      case '二线忙碌月页':
        if(tianhua2020.p6_city && tianhua2020.p6_hometown) {
          hypeDocument.showSceneNamed('参与多个项目页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
        } else if (tianhua2020.p6_prjno && tianhua2020.p6_totalarea && tianhua2020.p6_hometown) {
          hypeDocument.showSceneNamed('参与项目单城页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);  
        } else if (tianhua2020.p7_coworkprj && tianhua2020.p7_customer) {
          hypeDocument.showSceneNamed('参与项目详情页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);   
        } else if (tianhua2020.p8_design_prj && tianhua2020.p8_design_award) {
          hypeDocument.showSceneNamed('设计大奖页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);   
        } else if (tianhua2020.p9_design_meeting_times && tianhua2020.p9_design_meeting_score && tianhua2020.p9_design_meeting_rate) {
          hypeDocument.showSceneNamed('设计例会页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);   
        } else if (tianhua2020.p10_teacher_level && tianhua2020.p10_course_number) {
          hypeDocument.showSceneNamed('天华讲师页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);   
        } else if (tianhua2020.p11_finish_course && tianhua2020.p11_study_time && tianhua2020.p11_study_point && tianhua2020.p11_study_rate) {
          hypeDocument.showSceneNamed('天华学习页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);   
        } else {
          hypeDocument.showSceneNamed('逃学天华页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);   
        }
        break;
      case '参与多个项目页':
      case '参与项目单城页':
        if(tianhua2020.p7_coworkprj && tianhua2020.p7_customer) {
          hypeDocument.showSceneNamed('参与项目详情页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);   
        } else if (tianhua2020.p8_design_prj && tianhua2020.p8_design_award) {
          hypeDocument.showSceneNamed('设计大奖页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);   
        } else if (tianhua2020.p9_design_meeting_times && tianhua2020.p9_design_meeting_score && tianhua2020.p9_design_meeting_rate) {
          hypeDocument.showSceneNamed('设计例会页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);   
        } else if (tianhua2020.p10_teacher_level && tianhua2020.p10_course_number) {
          hypeDocument.showSceneNamed('天华讲师页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);   
        } else if (tianhua2020.p11_finish_course && tianhua2020.p11_study_time && tianhua2020.p11_study_point && tianhua2020.p11_study_rate) {
          hypeDocument.showSceneNamed('天华学习页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);   
        } else {
          hypeDocument.showSceneNamed('逃学天华页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);   
        }
        break;
      case '参与项目详情页':
        if(tianhua2020.p8_design_prj && tianhua2020.p8_design_award) {
          hypeDocument.showSceneNamed('设计大奖页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);   
        } else if (tianhua2020.p9_design_meeting_times && tianhua2020.p9_design_meeting_score && tianhua2020.p9_design_meeting_rate) {
          hypeDocument.showSceneNamed('设计例会页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);   
        } else if (tianhua2020.p10_teacher_level && tianhua2020.p10_course_number) {
          hypeDocument.showSceneNamed('天华讲师页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);   
        } else if (tianhua2020.p11_finish_course && tianhua2020.p11_study_time && tianhua2020.p11_study_point && tianhua2020.p11_study_rate) {
          hypeDocument.showSceneNamed('天华学习页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);   
        } else {
          hypeDocument.showSceneNamed('逃学天华页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);   
        }
        break;
      case '设计大奖页':
        if(tianhua2020.p9_design_meeting_times && tianhua2020.p9_design_meeting_score && tianhua2020.p9_design_meeting_rate) {
          hypeDocument.showSceneNamed('设计例会页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);   
        } else if (tianhua2020.p10_teacher_level && tianhua2020.p10_course_number) {
          hypeDocument.showSceneNamed('天华讲师页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);   
        } else if (tianhua2020.p11_finish_course && tianhua2020.p11_study_time && tianhua2020.p11_study_point && tianhua2020.p11_study_rate) {
          hypeDocument.showSceneNamed('天华学习页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);   
        } else {
          hypeDocument.showSceneNamed('逃学天华页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);   
        }
        break;
      case '设计例会页':
        if (tianhua2020.p10_teacher_level && tianhua2020.p10_course_number) {
          hypeDocument.showSceneNamed('天华讲师页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);   
        } else if (tianhua2020.p11_finish_course && tianhua2020.p11_study_time && tianhua2020.p11_study_point && tianhua2020.p11_study_rate) {
          hypeDocument.showSceneNamed('天华学习页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);   
        } else {
          hypeDocument.showSceneNamed('逃学天华页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);   
        }
        break;
      case '天华讲师页':
        if (tianhua2020.p11_finish_course && tianhua2020.p11_study_time && tianhua2020.p11_study_point && tianhua2020.p11_study_rate) {
          hypeDocument.showSceneNamed('天华学习页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);   
        } else {
          hypeDocument.showSceneNamed('逃学天华页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);   
        }
        break;
      case '天华学习页':
      case '逃学天华页':
        if (tianhua2020.p12_km_login_date && tianhua2020.p12_km_login_times && tianhua2020.p12_km_pop_part) {
          hypeDocument.showSceneNamed('知识管理页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
        } else if(tianhua2020.p13_new_title) {
          hypeDocument.showSceneNamed('职位晋升页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
        } else if(tianhua2020.p14_coparter_org_dept && tianhua2020.p14_coparter && tianhua2020.p14_coprj && tianhua2020.p14_cohours) {
          hypeDocument.showSceneNamed('亲密战友页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
        } else if(tianhua2020.p15_7777 && tianhua2020.p15_reimburse) {
          hypeDocument.showSceneNamed('报销求助页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
         }else if(tianhua2020.p16_teacher && tianhua2020.p16_adviser) {
          hypeDocument.showSceneNamed('导师班主任页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
        } else if(tianhua2020.p16_teacher) {
          hypeDocument.showSceneNamed('一位导师页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
        } else if(tianhua2020.p16_adviser) {
          hypeDocument.showSceneNamed('班主任页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
        } else {
          hypeDocument.showSceneNamed('寻找导师页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
        }
        break;
      case '知识管理页':
        if (tianhua2020.p13_new_title) {
          hypeDocument.showSceneNamed('职位晋升页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
        } else if (tianhua2020.p14_coparter_org_dept && tianhua2020.p14_coparter && tianhua2020.p14_coprj && tianhua2020.p14_cohours) {
          hypeDocument.showSceneNamed('亲密战友页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
        } else if (tianhua2020.p15_7777 && tianhua2020.p15_reimburse) {
          hypeDocument.showSceneNamed('报销求助页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
        } else if (tianhua2020.p16_teacher && tianhua2020.p16_adviser) {
          hypeDocument.showSceneNamed('导师班主任页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
        } else if (tianhua2020.p16_teacher) {
          hypeDocument.showSceneNamed('一位导师页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
        } else if (tianhua2020.p16_adviser) {
          hypeDocument.showSceneNamed('班主任页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
        } else {
          hypeDocument.showSceneNamed('寻找导师页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
        }
        break;
      case '职位晋升页':
        if (tianhua2020.p14_coparter_org_dept && tianhua2020.p14_coparter && tianhua2020.p14_coprj && tianhua2020.p14_cohours) {
          hypeDocument.showSceneNamed('亲密战友页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
        } else if (tianhua2020.p15_7777 && tianhua2020.p15_reimburse) {
          hypeDocument.showSceneNamed('报销求助页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
        } else if (tianhua2020.p16_teacher && tianhua2020.p16_adviser) {
          hypeDocument.showSceneNamed('导师班主任页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
        } else if (tianhua2020.p16_teacher) {
          hypeDocument.showSceneNamed('一位导师页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
        } else if (tianhua2020.p16_adviser) {
          hypeDocument.showSceneNamed('班主任页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
        } else {
          hypeDocument.showSceneNamed('寻找导师页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
        }
        break;
      case '亲密战友页':
        if (tianhua2020.p15_7777 && tianhua2020.p15_reimburse) {
            hypeDocument.showSceneNamed('报销求助页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
        } else if (tianhua2020.p16_teacher && tianhua2020.p16_adviser) {
            hypeDocument.showSceneNamed('导师班主任页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
        } else if (tianhua2020.p16_teacher) {
            hypeDocument.showSceneNamed('一位导师页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
        } else if (tianhua2020.p16_adviser) {
          hypeDocument.showSceneNamed('班主任页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
        } else {
          hypeDocument.showSceneNamed('寻找导师页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
        }
        break;
      case '报销求助页':
        if (tianhua2020.p16_teacher && tianhua2020.p16_adviser) {
          hypeDocument.showSceneNamed('导师班主任页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
        } else if (tianhua2020.p16_teacher) {
          hypeDocument.showSceneNamed('一位导师页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
        } else if (tianhua2020.p16_adviser) {
          hypeDocument.showSceneNamed('班主任页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
        } else {
          hypeDocument.showSceneNamed('寻找导师页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
        }
        break;
      case '导师班主任页':
      case '一位导师页':
      case '班主任页':
      case '寻找导师页':
        if (tianhua2020.p17_oa_login && tianhua2020.p17_oa_pv && tianhua2020.p17_oa_task) {
          hypeDocument.showSceneNamed('内网登录页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
        } else {
          hypeDocument.showSceneNamed('立FLAG页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
        }
        break;
      case '内网登录页':
        hypeDocument.showSceneNamed('立FLAG页', hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
        break;
      case '立FLAG页':
        hypeDocument.showSceneNamed('封面页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
        break;
      default:
        hypeDocument.showNextScene(hypeDocument.kSceneTransitionPushBottomToTop, 1.1);
        break;
    }
}
  
function showOrSkipPreviousSceneGlobal(hypeDocument) {
  var currentScene = hypeDocument.currentSceneName();
  switch (currentScene) {
    case '立FLAG页':
      if (tianhua2020.p17_oa_login && tianhua2020.p17_oa_pv && tianhua2020.p17_oa_task) {
        hypeDocument.showSceneNamed('内网登录页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p16_teacher && tianhua2020.p16_adviser) {
        hypeDocument.showSceneNamed('导师班主任页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p16_teacher) {
        hypeDocument.showSceneNamed('一位导师页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p16_adviser) {
        hypeDocument.showSceneNamed('班主任页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else {
        hypeDocument.showSceneNamed('寻找导师页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      }
      break;
    case '内网登录页':
      if (tianhua2020.p16_teacher && tianhua2020.p16_adviser) {
        hypeDocument.showSceneNamed('导师班主任页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p16_teacher) {
        hypeDocument.showSceneNamed('一位导师页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p16_adviser) {
        hypeDocument.showSceneNamed('班主任页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else {
        hypeDocument.showSceneNamed('寻找导师页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      }
      break;
    case '导师班主任页':
    case '一位导师页':
    case '班主任页':
    case '寻找导师页':
      if (tianhua2020.p15_7777 && tianhua2020.p15_reimburse) {
        hypeDocument.showSceneNamed('报销求助页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p14_coparter_org_dept && tianhua2020.p14_coparter && tianhua2020.p14_coprj && tianhua2020.p14_cohours) {
        hypeDocument.showSceneNamed('亲密战友页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p13_new_title) {
        hypeDocument.showSceneNamed('职位晋升页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p12_km_login_date && tianhua2020.p12_km_login_times && tianhua2020.p12_km_pop_part) {
        hypeDocument.showSceneNamed('知识管理页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p11_finish_course && tianhua2020.p11_study_time && tianhua2020.p11_study_point && tianhua2020.p11_study_rate) {
        hypeDocument.showSceneNamed('天华学习页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else {
        hypeDocument.showSceneNamed('逃学天华页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      }
      break;
    case '报销求助页':
      if (tianhua2020.p14_coparter_org_dept && tianhua2020.p14_coparter && tianhua2020.p14_coprj && tianhua2020.p14_cohours) {
        hypeDocument.showSceneNamed('亲密战友页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p13_new_title) {
        hypeDocument.showSceneNamed('职位晋升页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p12_km_login_date && tianhua2020.p12_km_login_times && tianhua2020.p12_km_pop_part) {
        hypeDocument.showSceneNamed('知识管理页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p11_finish_course && tianhua2020.p11_study_time && tianhua2020.p11_study_point && tianhua2020.p11_study_rate) {
        hypeDocument.showSceneNamed('天华学习页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else {
        hypeDocument.showSceneNamed('逃学天华页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      }
      break;
    case '亲密战友页':
      if (tianhua2020.p13_new_title) {
        hypeDocument.showSceneNamed('职位晋升页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p12_km_login_date && tianhua2020.p12_km_login_times && tianhua2020.p12_km_pop_part) {
        hypeDocument.showSceneNamed('知识管理页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p11_finish_course && tianhua2020.p11_study_time && tianhua2020.p11_study_point && tianhua2020.p11_study_rate) {
        hypeDocument.showSceneNamed('天华学习页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else {
        hypeDocument.showSceneNamed('逃学天华页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      }
      break;
    case '职位晋升页':
      if (tianhua2020.p12_km_login_date && tianhua2020.p12_km_login_times && tianhua2020.p12_km_pop_part) {
        hypeDocument.showSceneNamed('知识管理页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p11_finish_course && tianhua2020.p11_study_time && tianhua2020.p11_study_point && tianhua2020.p11_study_rate) {
        hypeDocument.showSceneNamed('天华学习页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else {
        hypeDocument.showSceneNamed('逃学天华页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      }
      break;
    case '知识管理页':
      if (tianhua2020.p11_finish_course && tianhua2020.p11_study_time && tianhua2020.p11_study_point && tianhua2020.p11_study_rate) {
        hypeDocument.showSceneNamed('天华学习页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else {
        hypeDocument.showSceneNamed('逃学天华页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      }
      break;
    case '天华学习页':
    case '逃学天华页':
      if (tianhua2020.p10_teacher_level && tianhua2020.p10_course_number) {
        hypeDocument.showSceneNamed('天华讲师页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p9_design_meeting_times && tianhua2020.p9_design_meeting_score && tianhua2020.p9_design_meeting_rate) {
        hypeDocument.showSceneNamed('设计例会页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p8_design_prj && tianhua2020.p8_design_award) {
        hypeDocument.showSceneNamed('设计大奖页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p7_coworkprj && tianhua2020.p7_customer) {
        hypeDocument.showSceneNamed('参与项目详情页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p6_city && tianhua2020.p6_hometown) {
        hypeDocument.showSceneNamed('参与多个项目页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p6_prjno && tianhua2020.p6_totalarea && tianhua2020.p6_hometown) {
        hypeDocument.showSceneNamed('参与项目单城页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p4_workcom) {
        hypeDocument.showSceneNamed('二线忙碌月页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p4_busymonth && tianhua2020.p4_busy_week) {
        hypeDocument.showSceneNamed('忙碌月周页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p3_workrate) {
        hypeDocument.showSceneNamed('忙碌程度页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else {
        hypeDocument.showSceneNamed('工时页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      }
      break;
    case '天华讲师页':
      if (tianhua2020.p9_design_meeting_times && tianhua2020.p9_design_meeting_score && tianhua2020.p9_design_meeting_rate) {
        hypeDocument.showSceneNamed('设计例会页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p8_design_prj && tianhua2020.p8_design_award) {
        hypeDocument.showSceneNamed('设计大奖页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p7_coworkprj && tianhua2020.p7_customer) {
        hypeDocument.showSceneNamed('参与项目详情页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p6_city && tianhua2020.p6_hometown) {
        hypeDocument.showSceneNamed('参与多个项目页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p6_prjno && tianhua2020.p6_totalarea && tianhua2020.p6_hometown) {
        hypeDocument.showSceneNamed('参与项目单城页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p4_workcom) {
        hypeDocument.showSceneNamed('二线忙碌月页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p4_busymonth && tianhua2020.p4_busy_week) {
        hypeDocument.showSceneNamed('忙碌月周页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p3_workrate) {
        hypeDocument.showSceneNamed('忙碌程度页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else {
        hypeDocument.showSceneNamed('工时页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      }
      break;
    case '设计例会页':
      if (tianhua2020.p8_design_prj && tianhua2020.p8_design_award) {
        hypeDocument.showSceneNamed('设计大奖页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p7_coworkprj && tianhua2020.p7_customer) {
        hypeDocument.showSceneNamed('参与项目详情页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p6_city && tianhua2020.p6_hometown) {
        hypeDocument.showSceneNamed('参与多个项目页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p6_prjno && tianhua2020.p6_totalarea && tianhua2020.p6_hometown) {
        hypeDocument.showSceneNamed('参与项目单城页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p4_workcom) {
        hypeDocument.showSceneNamed('二线忙碌月页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p4_busymonth && tianhua2020.p4_busy_week) {
        hypeDocument.showSceneNamed('忙碌月周页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p3_workrate) {
        hypeDocument.showSceneNamed('忙碌程度页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else {
        hypeDocument.showSceneNamed('工时页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      }
      break;
    case '设计大奖页':
      if (tianhua2020.p7_coworkprj && tianhua2020.p7_customer) {
        hypeDocument.showSceneNamed('参与项目详情页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p6_city && tianhua2020.p6_hometown) {
        hypeDocument.showSceneNamed('参与多个项目页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p6_prjno && tianhua2020.p6_totalarea && tianhua2020.p6_hometown) {
        hypeDocument.showSceneNamed('参与项目单城页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p4_workcom) {
        hypeDocument.showSceneNamed('二线忙碌月页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p4_busymonth && tianhua2020.p4_busy_week) {
        hypeDocument.showSceneNamed('忙碌月周页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p3_workrate) {
        hypeDocument.showSceneNamed('忙碌程度页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else {
        hypeDocument.showSceneNamed('工时页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      }
      break;
    case '参与项目详情页':
      if (tianhua2020.p6_city && tianhua2020.p6_hometown) {
        hypeDocument.showSceneNamed('参与多个项目页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p6_prjno && tianhua2020.p6_totalarea && tianhua2020.p6_hometown) {
        hypeDocument.showSceneNamed('参与项目单城页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p4_workcom) {
        hypeDocument.showSceneNamed('二线忙碌月页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p4_busymonth && tianhua2020.p4_busy_week) {
        hypeDocument.showSceneNamed('忙碌月周页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p3_workrate) {
        hypeDocument.showSceneNamed('忙碌程度页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else {
        hypeDocument.showSceneNamed('工时页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      }
      break;
    case '参与多个项目页':
    case '参与项目单城页':
      if (tianhua2020.p4_workcom) {
        hypeDocument.showSceneNamed('二线忙碌月页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p4_busymonth && tianhua2020.p4_busy_week) {
        hypeDocument.showSceneNamed('忙碌月周页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p3_workrate) {
        hypeDocument.showSceneNamed('忙碌程度页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else {
        hypeDocument.showSceneNamed('工时页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      }
      break;
    case '二线忙碌月页':
      if (tianhua2020.p4_busymonth && tianhua2020.p4_busy_week) {
        hypeDocument.showSceneNamed('忙碌月周页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else if (tianhua2020.p3_workrate) {
        hypeDocument.showSceneNamed('忙碌程度页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else {
        hypeDocument.showSceneNamed('工时页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      }
      break;
    case '忙碌月周页':
      if (tianhua2020.p3_workrate) {
        hypeDocument.showSceneNamed('忙碌程度页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      } else {
        hypeDocument.showSceneNamed('工时页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      }
      break;
    case '忙碌程度页':
      hypeDocument.showSceneNamed('工时页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      break;
    case '工时页':
      hypeDocument.showSceneNamed('工龄页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      break;
    case '工龄页':
      hypeDocument.showSceneNamed('封面页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      break;
    case '封面页':
      if (tianhua2020.flag_issued) {
        hypeDocument.showSceneNamed('立FLAG页', hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
        break;
      }
    default:
      hypeDocument.showPreviousScene(hypeDocument.kSceneTransitionPushTopToBottom, 1.1);
      break;
  }
}
  
function setElementGlobal(hypeDocument) {
  function setElement(element_id, content) {
      var element = hypeDocument.getElementById(element_id)
      if(element) {
        element.innerHTML=content;
      }
  }
  function hideElement(element_id) {
    var element = hypeDocument.getElementById(element_id);
    if(element) {
      element.style.display = "none";
    }
  }

  setElement('p1-name', tianhua2020.p1_name);
  setElement('p1-workbirthday', tianhua2020.p1_workbirthday);

  setElement('p3-workrate', tianhua2020.p3_workrate);

  setElement('p4-busymonth', tianhua2020.p4_busymonth);
  setElement('p4-busy-week', tianhua2020.p4_busy_week);
  setElement('p4-workcom', tianhua2020.p4_workcom);

  setElement('p6-prjno-1', tianhua2020.p6_prjno);
  setElement('p6-totalarea-1', tianhua2020.p6_totalarea);
  setElement('p6-city-1', tianhua2020.p6_city);
  setElement('p6-hometown-1', tianhua2020.p6_hometown);

  setElement('p6-prjno-2', tianhua2020.p6_prjno);
  setElement('p6-totalarea-2', tianhua2020.p6_totalarea);
  setElement('p6-hometown-2', tianhua2020.p6_hometown);

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

  setElement('p16-teacher-1', tianhua2020.p16_teacher);
  setElement('p16-teacher-2', tianhua2020.p16_teacher);
  setElement('p16-adviser-1', tianhua2020.p16_adviser);
  setElement('p16-adviser-2', tianhua2020.p16_adviser);

  setElement('p17-oa-login', tianhua2020.p17_oa_login);
  setElement('p17-oa-pv', tianhua2020.p17_oa_pv);
  setElement('p17-oa-task', tianhua2020.p17_oa_task);

  if(!tianhua2020.flag_issued) {
    hideElement('show-goto-flagboard');
  }
}

function gotoFlagBoardGlobal(hypeDocument) {
  window.location.href = `/tianhua2020s/${tianhua2020.clerk_code}/flag_board`;
}

export { submitFormButton, showOrSkipNextSceneGlobal, showOrSkipPreviousSceneGlobal, setElementGlobal, gotoFlagBoardGlobal }
