# frozen_string_literal: true

class Tianhua2020sController < ApplicationController
  wechat_api
  layout 'tianhua2020'

  def show
    release_date = DateTime.new(2021, 1, 22)
    r = Bill::Tianhua2020.find_by!(clerkcode: params[:id])

    @name = r.name
    @clerkcode = r.clerkcode
    p1_workbirthday = '<p style="margin-top: 0px; margin-bottom: 0px;"><span style="caret-color: rgb(228, 84, 73);"><b><font color="#df695a">1月22日</font></b></span><span style="color: rgb(41, 44, 54);">是我们的纪念日</span></p><p style="margin-top: 0px; margin-bottom: 0px;"><font>今年是我们相识的</font><b><font color="#df695a">' + (release_date - r.p1_firstday.to_date).ceil.to_s + '</font></b><font>天</font></p>'

    p3_workrate = if r.p3_workrate.present?
      '<p style="margin-top: 0px; margin-bottom: 0px; color: rgb(252, 241, 216);">你的忙碌程度已超过</p><p style="margin-top: 0px; margin-bottom: 0px;"><font color="#f9bf3d"><b style="font-size: 50px;">' + (r.p3_workrate * 100).round(0).to_s + '%</b><span style="font-size: 50px;"> </span></font><font color="#fcf1d8">的小伙伴</font></p>'
    end
    p4_busymonth = if r.p4_busymonth.present?
      '<font color="#f9bf3d" style="font-size: 50px;"><b>' + r.p4_busymonth.to_s + '月</b></font>是你最忙碌的一段时间，现在给自己五秒钟，回忆一下那段充实的时光吧'
    end
    p4_busy_week = if r.p4_busyweek.present?
      '每周<b style="font-size: 50px;"><font color="#f9bf3d">'+ max_workday(r.p4_busyweek).to_s+'</font></b>通常是你战斗力爆表的时刻'
    end
    p4_workcom = if r.p4_workcom.present?
      '<span style="font-size: 50px;"><font color="#f9bf3d"><b>' + r.p4_busymonth.to_s + '月</b></font></span>是<br><font color="#f9bf3d"><b><span style="font-size: 50px;">' + r.p4_workcom.to_s + '</span><br></b></font>最忙碌的月份<br>'
    end
    p6_prjno = if r.p6_prjno.present?
      '今年你共参与了<span style="font-size: 50px;"><b><font color="#df695a">' + r.p6_prjno.to_s + '</font></b></span>个项目'
    end
    p6_totalarea = if r.p6_totalarea.present?
      '<b style="font-size: 50px;"><font color="#df695a">' + r.p6_totalarea.to_s + '</font></b>平方米'
    end

    p6_city = if r.p6_city.present?
      r.p6_city.split(',').join(' &nbsp;')
    end

    p8_design_prj = if r.p8_design_prj.present?
      r.p8_design_prj.split('、').collect do |city|
        "<div>#{city}</div>"
      end.join
    end

    p9_design_meeting_times = if r.p9_design_meeting_times.present?
      '你共参加了<b style="font-size: 50px;"><font color="#f9bf3d">' + r.p9_design_meeting_times.to_s + '</font></b>次设计例会'
    end

    p9_design_meeting_score = if r.p9_design_meeting_score.present?
      '以平均汇报成绩<font color="#f9bf3d" style="font-size: 50px;"><b>' + r.p9_design_meeting_score.round(1).to_s + '</b></font>分'
    end

    p9_design_meeting_rate = if r.p9_design_meeting_rate.present?
      '<b style="font-size: 50px;"><font color="#f9bf3d">' + (r.p9_design_meeting_rate*100).round(0).to_s + '%</font></b>的小伙伴'
    end

    p10_teacher_level = if r.p10_teacher_level.present?
      '作为天华的<b style="font-size: 50px;"><font color="#df695a">' + r.p10_teacher_level.gsub('讲师','').to_s + '</font></b>讲师'
    end
    p10_course_number = '<b><font color="#df695a" style="font-size: 50px;">' + r.p10_course_number.to_s + '</font></b>次课程'

    p11_finish_course = '在这一年，你共完成了<font color="#f9bf3d"><b>' + r.p11_finish_course.to_i.to_s + '</b></font>门在线'
    p11_study_time = if r.p11_study_time.present?
      if r.p11_study_time.round(1) < 2
        '课程的学习，总时长<font color="#f9bf3d"><b>' + (r.p11_study_time.round(1)*60).to_s + '</b></font>分钟'
      else
        '课程的学习，总时长<font color="#f9bf3d"><b>' + r.p11_study_time.round(1).to_s + '</b></font>小时'
      end
    end
    p11_study_point = '可兑换<font color="#f9bf3d"><b>' + r.p11_study_point.to_s + '</b></font>积分'
    p11_study_rate = if r.p11_study_rate.present?
      '超过了<font color="#f9bf3d"><b>' + (r.p11_study_rate*100).round(0).to_s + '%</b></font>的小伙伴'
    end
    p11_study_award = if r.p11_study_award.present?
      r.p11_study_award.split(',').join('<br>').to_s
    else
      '<br><font color="#fdf3df" style="font-weight: normal;">学习证书</font>'
    end

    p12_km_login_date = '共有<font color="#df695a"><b>' + r.p12_km_login_date.to_s + '</b></font>天，你登陆过KM'
    p12_km_login_times = '点击次数<font color="#df695a"><b>' + r.p12_km_login_times.to_s + '</b></font>次'

    p14_coparter_org_dept = "#{r.p14_coparter_org}-#{r.p14_coparter_dept}"
    p14_cohours = '项目上共同奋战了<b><font color="#df695a">' + r.p14_cohours.to_s + '</font></b>小时'

    p15_7777 = if r.p15_7777.present?
      '<font color="#df695a"><b style="font-size: 50px;">' + r.p15_7777.to_i.to_s + '</b></font>次'
    end
    p15_reimburse = if r.p15_reimburse.present?
      '发起报销<font color="#df695a"><b style="font-size: 50px;">' + r.p15_reimburse.to_i.to_s + '</b></font>次'
    end

    p17_oa_login = if r.p17_oa_login.present?
      r.p17_oa_login.to_s + '<span style="font-size: 25px; font-weight: normal;"><font color="#363b46">天</font></span>'
    end
    p17_oa_pv = if r.p17_oa_pv.present?
      '<p style="margin-top: 0px; margin-bottom: 0px;"><font color="#292c36">点击了</font><span style="font-size: 50px;"><font color="#df695a"><b>' + r.p17_oa_pv.to_s + '</b></font></span><font color="#292c36">次</font></p>'
    end
    p17_oa_task = if r.p17_oa_task.present?
      '<p style="margin-top: 0px; margin-bottom: 0px;"><span style="font-size: 50px;"><font color="#df695a"><b>' + r.p17_oa_task.to_s + '</b></font></span><font color="#292c36">次</font></p >'
    end

    @tianhua2020 = {
      clerk_code: r.clerkcode,
      p1_name: r.name,
      p1_workbirthday: p1_workbirthday,
      p3_workrate: p3_workrate,
      p4_busymonth: p4_busymonth,
      p4_busy_week: p4_busy_week,
      p4_workcom: p4_workcom,
      p6_prjno: p6_prjno,
      p6_totalarea: p6_totalarea,
      p6_city: p6_city,
      p6_hometown: r.p6_hometown,
      p7_coworkprj: r.p7_coworkprj,
      p7_customer: r.p7_customer,
      p8_design_prj: p8_design_prj,
      p8_design_award: r.p8_design_award,
      p9_design_meeting_times: p9_design_meeting_times,
      p9_design_meeting_score: p9_design_meeting_score,
      p9_design_meeting_rate: p9_design_meeting_rate,
      p10_teacher_level: p10_teacher_level,
      p10_course_number: p10_course_number,
      p11_finish_course: p11_finish_course,
      p11_study_time: p11_study_time,
      p11_study_point: p11_study_point,
      p11_study_rate: p11_study_rate,
      p11_study_award: p11_study_award,
      p12_km_login_date: p12_km_login_date,
      p12_km_login_times: p12_km_login_times,
      p12_km_pop_part: r.p12_km_pop_part,
      p13_new_title: r.p13_new_title,
      p14_coparter_org_dept: p14_coparter_org_dept,
      p14_coparter: r.p14_coparter,
      p14_coprj: r.p14_coprj,
      p14_cohours: p14_cohours,
      p15_7777: p15_7777,
      p15_reimburse: p15_reimburse,
      p16_teacher: r.p16_teacher,
      p16_adviser: r.p16_adviser,
      p17_oa_login: p17_oa_login,
      p17_oa_pv: p17_oa_pv,
      p17_oa_task: p17_oa_task,
      flag_issued: Bill::Flag2020Board.find_by(from_clerkcode: r.clerkcode).present?
    }
  end


  def create
    clerk_code = params[:clerk_code]
    to_who_name = params[:to_who_name]
    message = params[:message]
    to_user = Bill::Tianhua2020.find_by(name: to_who_name.gsub('@', ''))
    Bill::Flag2020Board.create(from_clerkcode: clerk_code, to_clerkcode: to_user&.clerkcode, message: message)
    head :ok
  end

  def flag_board
    clerk_code = params[:id]
    @my_flags = Bill::Flag2020Board.where(from_clerkcode: clerk_code)

    @witness_flags = Bill::Flag2020Board.where(to_clerkcode: clerk_code)
  end

  private

    def years_between_dates(date_from, date_to = Date.new(2021, 1, 20))
      ((date_to - date_from) / 365).ceil
    end

    def max_workday(max_key)
      return '4' unless max_key.present?
      {
        Monday: '1',
        Tuesday: '2',
        Wednesday: '3',
        Thursday: '4',
        Friday: '5',
      }[max_key.to_sym]
    end
end
