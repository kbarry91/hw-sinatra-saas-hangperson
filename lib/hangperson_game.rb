class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end

  
  
  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  
  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses
  attr_accessor :guess

  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end
   # When a user makes a guess
  def guess(letter)
    #throw 'Error: Nil guess not allowed' if letter.nil?
    #throw 'Error: Empty guess' if letter == ''
    #throw 'Error: Guess not a letter' if !letter.match(/[a-zA-Z]/)
    raise ArgumentError if letter.nil?
    raise ArgumentError if letter == ''
    raise ArgumentError if !letter.match(/[a-zA-Z]/)

    
    letter.downcase!
    
    if word.include? letter
      unless guesses.include? letter
        guesses << letter
        for i in 0..word.length
          if word[i] == letter
            word_with_guesses[i] = letter
            @check_win_or_lose = :win if !word_with_guesses.include? '-'
          end
        end
        return true
      end
    else
      unless wrong_guesses.include? letter
        wrong_guesses << letter
        if wrong_guesses.size >= 7
          @check_win_or_lose = :lose
        end
        return true
      end
    end
    return false
  end
  
end
