require 'test_helper'

class LexiconTest < Test::Unit::TestCase
  include TestHelper
  
  context '' do
    setup do
      @item = mock
      @item.stubs(:pubDate).returns(DateTime.now)
    end

    should 'parse dollhouse.s02e08.internal.hdtv.xvid-2hd.avi' do
      @item.stubs(:title).returns('dollhouse.s02e08.internal.hdtv.xvid-2hd.avi')
      
      parsed = Lexicon::parse(@item)
      assert_equal 'dollhouse', parsed[:title]
      assert_equal 2, parsed[:series]
      assert_equal 8, parsed[:episode]
      assert parsed[:high_def]
    end

    should 'parse Ghost.Adventures.S03E07.HDTV.XviD-CRiMSON' do
       @item.stubs(:title).returns('Ghost.Adventures.S03E07.HDTV.XviD-CRiMSON')
      
      parsed = Lexicon::parse(@item)
      assert_equal 'Ghost Adventures', parsed[:title]
      assert_equal 3, parsed[:series]
      assert_equal 7, parsed[:episode]
      assert parsed[:high_def]     
    end

    should 'parse National.Geographic.Samurai.Sword.720p.HDTV.x264-DiCH' do
      @item.stubs(:title).returns('National.Geographic.Samurai.Sword.720p.HDTV.x264-DiCH')
      
      parsed = Lexicon::parse(@item)
      assert_equal 'National Geographic Samurai Sword', parsed[:title]
      assert_equal nil, parsed[:series]
      assert_equal nil, parsed[:episode]
      assert parsed[:high_def]     
    end

    should 'parse Hardcore TV (1994, HBO series)' do
      @item.stubs(:title).returns('Hardcore TV (1994, HBO series)')
      
      parsed = Lexicon::parse(@item)
      assert_equal 'Hardcore TV (1994, HBO series)', parsed[:title]
      assert_equal nil, parsed[:series]
      assert_equal nil, parsed[:episode]
      assert !parsed[:high_def]     
    end
    
    should 'parse Being.Erica.S02.INTERNAL.HDTV.XviD-BitMeTV' do
      @item.stubs(:title).returns('Being.Erica.S02.INTERNAL.HDTV.XviD-BitMeTV')
      
      parsed = Lexicon::parse(@item)
      assert_equal 'Being Erica', parsed[:title]
      assert_equal 2, parsed[:series]
      assert_equal nil, parsed[:episode]
      assert parsed[:high_def]     
    end

    should 'parse National.Geographic.Inside.The.Pentagon.Xvid.DVDRip.avi' do
      @item.stubs(:title).returns('National.Geographic.Inside.The.Pentagon.Xvid.DVDRip.avi')
      
      parsed = Lexicon::parse(@item)
      assert_equal 'National Geographic Inside The Pentagon', parsed[:title]
      assert_equal nil, parsed[:series]
      assert_equal nil, parsed[:episode]
      assert !parsed[:high_def]     
    end
  end
end
