class Tianhua2020sController < ApplicationController
    layout "tianhua2020"
  
    def show
      release_date = Date.new(2021, 1, 22)
      r = Tianhua2020.find_by!(clerkcode: params[:id])

      @name = r.name
      @clerkcode = r.clerkcode
  
      @tianhua2020 = {
      }
    end
  
    private
  
    def years_between_dates(date_from, date_to = Date.new(2021, 1, 20))
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
  
