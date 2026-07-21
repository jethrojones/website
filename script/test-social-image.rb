# frozen_string_literal: true

require "minitest/autorun"
require_relative "../_plugins/social_image"

class SocialImageTest < Minitest::Test
  Item = Struct.new(:data, :content)

  def test_preserves_explicit_frontmatter_image
    item = Item.new({ "image" => "/assets/explicit.jpg" }, '<img src="/assets/body.jpg">')

    JethroSite::SocialImage.apply(item, "/assets/fallback.png")

    assert_equal "/assets/explicit.jpg", item.data["image"]
  end

  def test_uses_first_rendered_image
    item = Item.new({}, '<p>Intro</p><img alt="First" src="assets/first.jpg"><img src="/assets/second.jpg">')

    JethroSite::SocialImage.apply(item, "/assets/fallback.png")

    assert_equal "/assets/first.jpg", item.data["image"]
  end

  def test_supports_single_quotes_and_html_entities
    item = Item.new({}, "<img data-src='https://example.com/image.jpg?width=1200&amp;quality=80'>")

    JethroSite::SocialImage.apply(item, "/assets/fallback.png")

    assert_equal "https://example.com/image.jpg?width=1200&quality=80", item.data["image"]
  end

  def test_uses_fallback_when_page_has_no_image
    item = Item.new({ "image" => "" }, "<p>No picture here.</p>")

    JethroSite::SocialImage.apply(item, "/assets/fallback.png")

    assert_equal "/assets/fallback.png", item.data["image"]
  end
end

# Created by Codex GPT-5.6 on 2026-07-21 12:07 PT on Jethro-MBP
