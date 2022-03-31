class DashboardsController < ApplicationController
    def show
      if (Variable.find_by(var_name: 'max_limit') == nil) then
        @variable = Variable.new
        @variable.var_name = 'max_limit'
        @variable.var_value = '3'
        @variable.save
      end
    end
  end