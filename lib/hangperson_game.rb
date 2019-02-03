class HangpersonGame

  # use attr_accessor to allow reading and writing of instance variables
  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses
  attr_accessor :word_with_guesses 
  attr_accessor :check_win_or_lose
  
  # Initialize game variables
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
     @word_with_guesses = ''
    word.each_char do |i|
      # initially just all dashes
      @word_with_guesses << '-'
    end
    @check_win_or_lose = :play
  end
  
  # Get a word from remote "random word" service
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
    raise ArgumentError if letter.nil?
    
    #throw 'Error: Empty guess' if letter == ''
    raise ArgumentError if letter == ''
    
    #throw 'Error: Guess not a letter' if !letter.match(/[a-zA-Z]/)
    raise ArgumentError if !letter.match(/[a-zA-Z]/)

    # Convert letter to lowercase
    letter.downcase!
    
    # Check if letter is in word unless letter already guessed
    if word.include? letter
      unless guesses.include? letter
        # Add letter to guess array
        guesses << letter
        
        # Iterate through word
        for i in 0..word.length
          if word[i] == letter
            word_with_guesses[i] = letter
            # If all - replaced set check_win_or_lose to win
            @check_win_or_lose = :win if !word_with_guesses.include? '-'
          end
        end
        
        return true
      end
    else
      unless wrong_guesses.include? letter
        # Add letter to wrong_guesses array
        wrong_guesses << letter
        
        # If 7 wrong guesses entered
        if wrong_guesses.size >= 7
          # Set check_win_or_lose to lose
          @check_win_or_lose = :lose
        end
        
        return true
      end
    end
    # Word does not contain guessed letter return false
    return false
  end
  
end
