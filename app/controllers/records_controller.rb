class RecordsController < ApplicationController
  before_action :set_record, only: [:show, :edit, :update, :destroy]
  # turned off because have configuration issue
  skip_before_action :verify_authenticity_token

  def index
    @records = Record.order('created_at DESC')
  end

  def show
  end

  def new
    @record = Record.new
  end

  def edit
  end

  def create
    @record = Record.new(record_params)

    respond_to do |format|
      if @record.save
        format.json { render :show, status: :created, location: @record }
      else
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @record.update(record_params)
        format.json { render :show, status: :ok, location: @record }
      else
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @record.destroy
    redirect_back fallback_location: admin_path
  end

  private
    def set_record
      @record = Record.find(params[:id])
    end

    def record_params
      params.require(:record).permit(:name, chunks_attributes: [:id, :start_at, :source])
    end
end
