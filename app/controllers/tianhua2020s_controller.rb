# frozen_string_literal: true

class Tianhua2020sController < ApplicationController
  wechat_api
  layout "tianhua2020"

  def show
    release_date = DateTime.new(2021, 1, 22)
    r = Bill::Tianhua2020.find_by!(clerkcode: params[:id])

    @name = r.name
    @clerkcode = r.clerkcode
    p1_workbirthday = '<p style="margin-top: 0px; margin-bottom: 0px;"><span style="caret-color: rgb(228, 84, 73);"><b><font color="#df695a">' + "#{r.p1_firstday.month}月#{r.p1_firstday.day}" + '日</font></b></span><span style="color: rgb(41, 44, 54);">是我们的相识纪念日</span></p><p style="margin-top: 0px; margin-bottom: 0px;"><font>今天是我们相识的</font><b><font color="#df695a">' + (release_date - r.p1_firstday.to_date).ceil.to_s + "</font></b><font>天</font></p>"

    p3_workrate = if r.p3_workrate.present?
      '<p style="margin-top: 0px; margin-bottom: 0px; color: rgb(252, 241, 216);">你的忙碌程度已超过</p><p style="margin-top: 0px; margin-bottom: 0px;"><font color="#f9bf3d"><b style="font-size: 50px;">' + (r.p3_workrate * 100).round(0).to_s + '%</b><span style="font-size: 50px;"> </span></font><font color="#fcf1d8">的小伙伴</font></p>'
    end
    p4_busymonth = if r.p4_busymonth.present?
      '<font color="#f9bf3d" style="font-size: 50px;"><b>' + r.p4_busymonth.to_s + "月</b></font>是你最忙碌的一段时间，现在给自己五秒钟，回忆一下那段充实的时光吧"
    end
    p4_busy_week = if r.p4_busyweek.present?
      '每周<b style="font-size: 50px;"><font color="#f9bf3d">' + max_workday(r.p4_busyweek).to_s + "</font></b>通常是你战斗力爆表的时刻"
    end
    p4_workcom = if r.p4_workcom.present?
      '<span style="font-size: 50px;"><font color="#f9bf3d"><b>' + r.p4_busymonth.to_s + '月</b></font></span>是<br><font color="#f9bf3d"><b><span style="font-size: 50px;">' + r.p4_workcom.to_s + "</span><br></b></font>最忙碌的月份<br>"
    end
    p6_prjno = if r.p6_prjno.present?
      '今年你共参与了<span style="font-size: 50px;"><b><font color="#df695a">' + r.p6_prjno.to_s + "</font></b></span>个项目"
    end
    p6_totalarea = if r.p6_totalarea.present?
      '<b style="font-size: 50px;"><font color="#df695a">' + r.p6_totalarea.to_s + "</font></b>平方米"
    end

    p6_city = if r.p6_city.present?
      r.p6_city.split(",").join(" &nbsp;")
    end

    p8_design_prj = if r.p8_design_prj.present?
      r.p8_design_prj.split("、").collect do |city|
        "<div>#{city}</div>"
      end.join
    end

    p9_design_meeting_times = if r.p9_design_meeting_times.present?
      '你共参加了<b style="font-size: 50px;"><font color="#f9bf3d">' + r.p9_design_meeting_times.to_s + "</font></b>次设计例会"
    end

    p9_design_meeting_score = if r.p9_design_meeting_score.present?
      '以平均汇报成绩<font color="#f9bf3d" style="font-size: 50px;"><b>' + r.p9_design_meeting_score.round(1).to_s + "</b></font>分"
    end

    p9_design_meeting_rate = if r.p9_design_meeting_rate.present?
      '<b style="font-size: 50px;"><font color="#f9bf3d">' + (r.p9_design_meeting_rate * 100).round(0).to_s + "%</font></b>的小伙伴"
    end

    p10_teacher_level = if r.p10_teacher_level.present?
      '作为天华的<b style="font-size: 50px;"><font color="#df695a">' + r.p10_teacher_level.gsub("讲师", "").to_s + "</font></b>讲师"
    end
    p10_course_number = '<b><font color="#df695a" style="font-size: 50px;">' + r.p10_course_number.to_s + "</font></b>次课程"

    p11_study_time = if r.p11_study_time.present?
      if r.p11_study_time.ceil < 2
        '在这一年，你一共在【在线学习平台】学习了<font color="#f9bf3d"><b>' + (r.p11_study_time.ceil * 60).to_s + "</b></font>分钟"
      else
        '在这一年，你一共在【在线学习平台】学习了<font color="#f9bf3d"><b>' + r.p11_study_time.ceil.to_s + "</b></font>小时"
      end
    end
    p11_study_point = '可兑换<font color="#f9bf3d"><b>' + r.p11_study_point.to_s + "</b></font>积分"
    p11_study_rate = if r.p11_study_rate.present?
      '超过了<font color="#f9bf3d"><b>' + (r.p11_study_rate * 100).round(0).to_s + "%</b></font>的小伙伴"
    end
    p11_study_award = if r.p11_study_award.present?
      awards = r.p11_study_award.split(",").uniq
      if awards.length <= 3
        '在这一年里<br>你的努力学习也收获了<br><b><font color="#f9bf3d">' + awards.join("<br>").to_s + "</font></b><br>"
      elsif awards.length <= 5
        '<font size="4">在这一年里<br>你的努力学习也收获了<br><b><font color="#f9bf3d">' + awards.join("<br>").to_s + "</font></b><br></font>"
      elsif awards.length <= 7
        '<font size="2" style="line-height: 1;">在这一年里<br>你的努力学习也收获了<br><b><font color="#f9bf3d">' + awards.join("<br>").to_s + "</font></b><br></font>"
      else
        '<font size="1" style="line-height: 1;">在这一年里<br>你的努力学习也收获了<br><b><font color="#f9bf3d">' + awards.join("<br>").to_s + "</font></b><br></font>"
      end
    else
      '<br><font color="#fdf3df" style="font-weight: normal;">利用工作间隙为自己充电这是一个很好的习惯！</br>加油，在线学习管理平台愿意做你的贴身学伴~</font>'
    end

    p12_km_login_date = '共有<font color="#df695a"><b>' + r.p12_km_login_date.to_s + "</b></font>天，你登录过KM"
    p12_km_login_times = '点击次数<font color="#df695a"><b>' + r.p12_km_login_times.to_s + "</b></font>次"

    p14_coparter_org_dept = "#{r.p14_coparter_org}-#{r.p14_coparter_dept}"
    p14_cohours = '项目上共同奋战了<b><font color="#df695a">' + r.p14_cohours.to_s + "</font></b>小时"

    p15_7777 = if r.p15_7777.present?
      '<font color="#df695a"><b style="font-size: 50px;">' + r.p15_7777.to_i.to_s + "</b></font>次"
    end
    p15_reimburse = if r.p15_reimburse.present?
      '发起报销<font color="#df695a"><b style="font-size: 50px;">' + r.p15_reimburse.to_i.to_s + "</b></font>次"
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
      flag_issued: Bill::Flag2020Board.find_by(from_clerkcode: r.clerkcode).present?,
      playing_music: false
    }
  end

  def index
    wechat_oauth2 do |wecom_id|
      tianhua2020 = Bill::Tianhua2020.find_by wecom_id: wecom_id
      if tianhua2020.present?
        return redirect_to tianhua2020_path(id: tianhua2020.clerkcode)
      else
        return render
      end
    end
  end

  def create
    clerk_code = params[:clerk_code]
    to_who_name = params[:to_who_name]
    message = params[:message]
    from_clerk = Bill::Tianhua2020.find_by(clerkcode: clerk_code)
    if from_clerk.present? && message.present? && Date.today < Date.new(2021, 1, 29)
      names = to_who_name.to_s.split(/[\s,，、]/)
      if names.present?
        names.each do |name|
          pure_name = name.delete("@")
          to_users = Bill::Tianhua2020.where(name: pure_name, deptcode_sum: from_clerk.deptcode_sum)
          to_users = Bill::Tianhua2020.where(name: pure_name, orgcode: from_clerk.orgcode) unless to_users.present?
          to_users = Bill::Tianhua2020.where(name: pure_name) unless to_users.present?
          to_users.each do |to_user|
            Bill::Flag2020Board.create(from_clerkcode: clerk_code, to_clerkcode: to_user.clerkcode, message: message)
          end
        end
      else
        Bill::Flag2020Board.create(from_clerkcode: clerk_code, message: message)
      end
    end
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
    return "4" unless max_key.present?
    {
      Monday: "1",
      Tuesday: "2",
      Wednesday: "3",
      Thursday: "4",
      Friday: "5"
    }[max_key.to_sym]
  end
end
