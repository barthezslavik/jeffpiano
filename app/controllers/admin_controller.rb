class AdminController < ApplicationController
  def main
    @records = Record.all
  end
end
