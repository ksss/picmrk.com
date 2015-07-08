require 'securerandom'

module Base58
  class InvalidCharError < StandardError; end

  WORDS = %w(
      1 2 3 4 5 6 7 8 9
    a b c d e f g h i j k   m n o p q r s t u v w x y z
    A B C D E F G H   J K L M N   P Q R S T U V W X Y Z
  ).freeze
  WORD_MAP = WORDS.each_with_index.to_h.freeze

  module_function def key_digest58(n = 16)
    encode58 SecureRandom.random_bytes(n)
  end

  module_function def encode58(data)
    digest_num = data.unpack("C*").inject(0){ |r, i|
      r = r << 8
      r += i
    }
    encode58_num2str(digest_num)
  end

  module_function def encode58_num2str(num)
    chars = []
    loop do
      chars << WORDS[num % 58]
      num /= 58
      break unless 0 < num
    end
    chars.reverse.join
  end

  module_function def decode58(data)
    chars = []
    num = decode58_str2num(data)
    while 0 < num
      chars << (num & 0xFF)
      num = num >> 8
    end
    chars.reverse.map(&:chr).join
  end

  module_function def decode58_str2num(data)
    return "1" if data == ""

    sum = 0
    data.each_char.to_a.reverse.map { |ch|
      index = WORD_MAP[ch]
      fail InvalidCharError unless index
      index
    }.each_with_index.inject(0) { |result, (ch, index)|
      result += ch * (58 ** index)
    }
  end
end
