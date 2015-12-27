class PradLibTemplatePool
  def initialize arr
    @members = arr
  end

  def pick
    raise 'Empty pool' if @members.empty?
    @members.sample
  end
end
