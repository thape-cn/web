# frozen_string_literal: true

class Tianhua2019sController < ApplicationController
  wechat_api
  layout 'tianhua2019'

  def show
    release_date = Date.new(2020, 1, 20)
    r = Bill::Tianhua2019.find_by!(clerkcode: params[:id])
    page2_age = years_between_dates(r.firstday)
    page2_day = "#{(release_date - r.firstday).floor}<span style='caret-color: rgb(57, 106, 141); color: rgb(57, 106, 141); font-family: -apple-system, BlinkMacSystemFont, &quot;Helvetica Neue&quot;, Arial, &quot;PingFang SC&quot;, &quot;Hiragino Sans GB&quot;, STHeiti, &quot;Microsoft YaHei&quot;, &quot;Microsoft JhengHei&quot;, &quot;Source Han Sans SC&quot;, &quot;Noto Sans CJK SC&quot;, &quot;Source Han Sans CN&quot;, &quot;Noto Sans SC&quot;, &quot;Source Han Sans TC&quot;, &quot;Noto Sans CJK TC&quot;, &quot;WenQuanYi Micro Hei&quot;, SimSun, sans-serif; font-size: 24px; font-weight: normal;'>天</span>".html_safe
    page2_comment = if page2_age >= 3
      '我们之间的默契，旁人无法了解'
    elsif page2_age > 1 && page2_age < 3
      '我们都已经习惯了彼此的陪伴'
    else
      '蜜月总会过去，未来定会更好'
    end

    page3_busy_percent = if r.rank.present?
      "#{(r.rank*100).to_i}%"
    end
    page3_filling_rate = if r.fill_rate.present?
      if r.fill_rate < 0.01
        '1%'
      else
        "#{(r.fill_rate*100).to_i}%"
      end
    end
    page3_comment = if r.fill_rate.present?
      if r.fill_rate >= 0.95
        '你的灵魂伴侣除了CAD还有我～<br>继续加油'.html_safe
      elsif r.fill_rate >= 0.60 && r.fill_rate < 0.95
        '有那么几天你忘了和我“见面”<br>但我依然在等着你！'.html_safe
      else
        '你没有填报的第一天，想你…<br>你没有填报的第N天，想你xN…'.html_safe
      end
    end
    page3_busy_month = r.max_month.month
    page3_busy_workday = max_workday(r.max_weekday)

    page3a_blank_word = "月是#{r.max_month_unit}"

    page5_complete_area = if r.prj_area.present?
      "#{r.prj_area.to_i}<font face='-apple-system, BlinkMacSystemFont, Helvetica Neue, Arial, PingFang SC, Hiragino Sans GB, STHeiti, Microsoft YaHei, Microsoft JhengHei, Source Han Sans SC, Noto Sans CJK SC, Source Han Sans CN, Noto Sans SC, Source Han Sans TC, Noto Sans CJK TC, WenQuanYi Micro Hei, SimSun, sans-serif' size='4' style='font-weight: normal;' color='#386a8e'>平方米</font>".html_safe
    end
    page5a_certificate = if r.certificate.present?
      r.certificate.split(',').reject(&:blank?).join('<br />').html_safe
    end
    page6_course_num = if r.learn_course.present?
      "你今年一共学习了<b><font face='Avenir, Helvetica, Arial, sans-serif' color='#ffaa48' size='7'>#{r.learn_course}</font></b>个课程".html_safe
    end
    page6_course_hour = if r.study_hours.present?
      "累计<font face='Avenir, Helvetica, Arial, sans-serif' size='7' color='#ffaa48'><b>#{r.study_hours.to_i}</b></font>小时的学习时间".html_safe
    end

    page9_plugin_name = if r.skywalker.present?
      r.skywalker.split('/n').join('<br />').html_safe
    end

    page10_project_name_hours = if r.max_parter_project3.present?
      "#{r.max_parter_project1}<br />#{r.max_parter_project2}<br />#{r.max_parter_project3}<br /><div><font color='#396a8d' style='font-weight: normal;'>项目上鏖战了</font><br></div><div><font size='7' face='Avenir, Helvetica, Arial, sans-serif'>#{r.max_parter_hours}</font><font color='#396a8d' style='font-weight: normal;'>小时</font></div>".html_safe
    elsif r.max_parter_project2.present?
      "#{r.max_parter_project1}<br />#{r.max_parter_project2}<br /><div><font color='#396a8d' style='font-weight: normal;'>项目上鏖战了</font><br></div><div><font size='7' face='Avenir, Helvetica, Arial, sans-serif'>#{r.max_parter_hours}</font><font color='#396a8d' style='font-weight: normal;'>小时</font></div>".html_safe
    else
      "#{r.max_parter_project1}<br /><div><font color='#396a8d' style='font-weight: normal;'>项目上鏖战了</font><br></div><div><font size='7' face='Avenir, Helvetica, Arial, sans-serif'>#{r.max_parter_hours}</font><font color='#396a8d' style='font-weight: normal;'>小时</font></div>".html_safe
    end

    page10_hours = if r.max_parter_hours.present?
      "#{r.max_parter_hours}"
    end

    page11_folk_course = if r.old_folk_course.present?
      "是你#{r.old_folk_course}的同学".html_safe
    end
    page11_folk_alumni = if r.folk_alumni_sign.present?
      "有<font face='Avenir, Helvetica, Arial, sans-serif' color='#ffaa48'><b style='font-size: 64px;'>#{r.folk_alumni_sign.to_i}</b></font>人既是你的老乡".html_safe
    end

    page14_ai_tools_major = if r.major.present?
      "<span style='caret-color: rgb(58, 106, 141); color: rgb(58, 106, 141); font-size: 18px; font-weight: normal; text-align: left; white-space: nowrap;'>据说</span>#{r.major}<span style='caret-color: rgb(58, 106, 141); color: rgb(58, 106, 141); font-size: 18px; font-weight: normal; text-align: left; white-space: nowrap;'>的</span>".html_safe
    end

    page14_ai_tools_name = if r.best_addin.present?
      "#{r.best_addin}<span style='caret-color: rgb(58, 106, 141); color: rgb(58, 106, 141); font-size: 18px; font-weight: normal; white-space: nowrap;'>工具最好用哦</span>".html_safe
    end

    @name = r.name
    @clerkcode = r.clerkcode

    @tianhua2019 = {
      page2_age: page2_age,
      page2_day: page2_day,
      page2_comment: page2_comment,
      page3_busy_percent: page3_busy_percent,
      page3_busy_month: page3_busy_month,
      page3_busy_workday: page3_busy_workday,
      page3_filling_rate: page3_filling_rate,
      page3_comment: page3_comment,
      page3_max_month_unit: r.max_month_unit,
      page3a_busy_month: page3_busy_month,
      page3a_blank_word: page3a_blank_word,
      page4_project_num: r.prjno,
      page4_project_owner: r.max_serve_client,
      page4_project_name: r.max_projectname,
      page4_work_day: r.max_workdays,
      page5_complete_area: page5_complete_area,
      page5_football_num: ((r.prj_area||0)/137.5).to_i,
      page5_working_city: r.work_place,
      page5_hometown: r.home_town.presence,
      page5a_certificate: page5a_certificate,
      page5b_company: r.upgrade_org,
      page5b_title: r.upgrade_postname,
      page6_course_num: page6_course_num,
      page6_course_hour: page6_course_hour,
      page7_award: r.micro_course,
      page8_my_students: r.student_no,
      page8_my_course: r.pop_course,
      page8_my_attendance: r.learn_times&.to_i,
      page9_nickname: 'Skywalker',
      page9_plugin_name: page9_plugin_name,
      page10_name: r.max_parter_name,
      page10_project_name_hours: page10_project_name_hours,
      page10_hours: page10_hours,
      page11_name: r.old_folk,
      page11_folk_course: page11_folk_course,
      page11_folk_alumni: page11_folk_alumni,
      page12_name: r.teacher,
      page13_call_count: r.service_times,
      page14_ai_tools_major: page14_ai_tools_major,
      page14_ai_tools_name: page14_ai_tools_name
    }
  end

  def index
    wechat_oauth2 do |user_name|
      tianhua2019 = Bill::Tianhua2019.find_by email: "#{user_name}@thape.com.cn"
      if tianhua2019.present?
        return redirect_to tianhua2019_path(id: tianhua2019.clerkcode)
      else
        return render
      end
    end
  end

  private

    def years_between_dates(date_from, date_to = Date.new(2020, 1, 20))
      ((date_to - date_from) / 365).ceil
    end

    def max_workday(max_key)
      return '周四' unless max_key.present?
      {
        Monday: '周一',
        Tuesday: '周二',
        Wednesday: '周三',
        Thursday: '周四',
        Friday: '周五',
      }[max_key.to_sym]
    end
end
