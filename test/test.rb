#
# gitコマンドのテストとか大変かも...
#

require 'minitest'
require 'minitest/unit'

MiniTest::autorun

class TestFoo < MiniTest::Unit::TestCase
  def setup
    @cwd = Dir.getwd

    #
    # Gitレポジトリを作成
    #
    system "/bin/rm -r -f __testdir"
    system "mkdir __testdir"
    system "cd __testdir; git init --quiet"
    system "cd __testdir; date > abc"
    system "cd __testdir; git add abc"
    system "cd __testdir; git commit -a -m 'message' --quiet"
  end

  def teardown
    system "/bin/rm -r -f __testdir"
  end

  def check(q,pat,dir=".")
    res = false
    `cd #{dir}; ruby #{@cwd}/exe/helpline -t '#{q}'`.split(/\n/).each { |line|
      #puts "pat = #{pat}"
      #puts "line = #{line}"
      #puts pat.match(line)
      if line.match(pat)
        #puts "====================="
        res = true
      end
    }
    assert res
  end

  def test_自転車
    check "自転車", "「自転車」という文字列を含むファイルを捜す"
    check "自転車", "grep"
  end

  def test_天気
    check "天気", "鎌倉"
    check "天気", "天気"
  end

  def test_git_削除
    #
    # gitリポジトリでは削除メニューが出ることを確認
    #
    check "abc 削除", /abc.*ファイル.*削除/, "__testdir"
  end

  def test_git_ブランチ
    check "ブランチ", /branch/, "__testdir"
  end
end