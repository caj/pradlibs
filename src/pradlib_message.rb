require 'octokit'

class PradLibMessage
  attr_reader :message

  def initialize octokit
    @pr = octokit
    setup_adlibs
    setup_pool
    create_message
  end

  private

  def create_message
    m = @pool.sample
    keywords = @libs.keys.map(&:to_s)
    message = m.scan(/([\w]+|,|'\w|\?|\.)/).to_a.flatten.inject('') do |acc, w|
      if keywords.include? w
        acc + @libs[w.to_sym].sample.to_s + ' '
      elsif w == "'s"
        acc[0..-2] + w + ' '
      else
        acc + w + ' '
      end
    end

    @message = message.split.map(&:capitalize).inject('') { |acc, x| if x == ',' then acc + x else acc + ' ' + x end }

    @message = {
      response_type: "in_channel",
      text: @message.strip,
    }
  end

  def setup_adlibs
    @data = {
      REPO: [*@pr.base.repo.name],
      ADD: [*@pr.additions],
      DEL: [*@pr.deletions],
      USER: [*@pr.user.login],
      TOTAL: [*(@pr.additions + @pr.deletions)],
      NET: [*(@pr.additions - @pr.deletions)],
    }

    # "at"libs... ah ha ha
    @libs = @data.merge BASE_ADLIBS.dup
  end

  def setup_pool
    add = @libs[:ADD][0]
    del = @libs[:DEL][0]

    @pool = MESSAGES[:regular].dup

    if add > del
      @pool += MESSAGES[:net_gain].dup
    elsif add < del
      @pool += MESSAGES[:net_loss].dup
    end

    @pool += MESSAGES[:only_gain].dup if add && del == 0
    @pool += MESSAGES[:only_loss].dup if add == 0 && del
  end
end

MESSAGES = {

  regular: [
    "PREFIX GROUP's TOTAL most WANTED changes for REPO",
    "GROUP, GROUP, and GROUP unite in support of these TOTAL changes to REPO",
    "try not to cry when you see these TOTAL changes",
    "scientists uncover DEL BADJ DELWORD and ADD GADJ ADDWORD that SUFFIX",
    "USER made TOTAL changes to REPO, and you won't believe what happened!",
    "what happens when you make TOTAL changes to REPO? USER found out, and you can too.",
    "USER ADDWORD2 ADD things, then DELWORD2 DEL things. what happened next will shock you",
    "TOTAL GADJ ways to make REPO a better place"
  ],

  net_gain: [
    "NET BADJ ADDWORD that SUFFIX",
    "NET GADJ ADDWORD that SUFFIX"
  ],

  net_loss: [
    "DEL GADJ, GADJ DELWORD that SUFFIX",
    "PREFIX the BADJ DELWORD which you'll love to see DELWORD2!",
    "watch USER become an inspiration with NET DELWORD"
  ],

  only_gain: [
    "PREFIX USER ADDWORD2 ADD ADDWORD, and SUFFIX."
  ],

  only_loss: [
    "USER DELWORD2 DEL lines from REPO, and you won't *believe* what they did next!",
    "DEL facts that prove the world isn't such a bad place",
    "REPO repo is slimming down for summer with these TOTAL GADJ secrets"
  ],

}

BASE_ADLIBS = {
  PREFIX: [
    "you won't believe this!",
    "staff pick:",
    "breaking news!",
    "the votes are in:"
  ],

  GROUP: [
    "the city", "the state",
    "our nation","the country", "america", "the united states", "the ol' u-s of a",
    "north america", "south america", "europe", "asia", "africa", "austrailia", "antarctica",
    "a hitherto unknown sect", "a clan of ninja warriors", "a clan of viking berserkers",
  ],

  BADJ: [ # bad adjective
    "painful", "horrible", "terrible", "awful", "sad", "mortifying", "ugly"
  ],

  GADJ: [
    "great", "awesome", "fantastic", "amazing", "cool", "sexy"
  ],

  WANTED: [ # seriously I'm just throwing out categories
    "wanted", "needed", "desired", "sought after"
  ],

  ADDWORD: ["additions", "additional lines", "new lines of code" ],
  ADDWORD2: ["added", "contributed", "typed", "inserted"],
  DELWORD: ["deletions", "fewer lines"],
  DELWORD2: ["deleted", "destroyed", "removed", "hacked away", "got rid of", "blew away", "vanquished", "nuked", "rampaged through"],

  SUFFIX: [
    "only developers will understand",
    "will surprise you",
    "managers just can't accept",
    "you have to see to believe",
    "will blow. your. mind.",
    "will never make sense",
    "are really fundamental truths of the universe",
    "will confound and surprise you",
    "you have to see to believe",
    "will change your life",
    "will leave you breathless",
  ]
}
