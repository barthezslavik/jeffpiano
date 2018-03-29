require "application_system_test_case"

class ChunksTest < ApplicationSystemTestCase
  setup do
    @chunk = chunks(:one)
  end

  test "visiting the index" do
    visit chunks_url
    assert_selector "h1", text: "Chunks"
  end

  test "creating a Chunk" do
    visit chunks_url
    click_on "New Chunk"

    fill_in "Record", with: @chunk.record_id
    fill_in "Source", with: @chunk.source
    fill_in "Start At", with: @chunk.start_at
    click_on "Create Chunk"

    assert_text "Chunk was successfully created"
    click_on "Back"
  end

  test "updating a Chunk" do
    visit chunks_url
    click_on "Edit", match: :first

    fill_in "Record", with: @chunk.record_id
    fill_in "Source", with: @chunk.source
    fill_in "Start At", with: @chunk.start_at
    click_on "Update Chunk"

    assert_text "Chunk was successfully updated"
    click_on "Back"
  end

  test "destroying a Chunk" do
    visit chunks_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Chunk was successfully destroyed"
  end
end
