# frozen_string_literal: true

module CommonStuff
  def destroy_uni_update(sid)
    @student = Student.find(sid)
    @university = University.find(@student.university_id)
    if @student.exchange_term.include?('and')
      @university.update!(num_nominees: @university.num_nominees - 2)
    else
      @university.update!(num_nominees: @university.num_nominees - 1)
    end
  end
end
