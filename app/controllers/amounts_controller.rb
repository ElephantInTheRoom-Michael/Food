class AmountsController < ApplicationController
  before_action :set_amount, only: %i[ show edit update ] # destroy ]

  # GET /amounts or /amounts.json
  def index
    @amounts = Amount.all
  end

  # GET /amounts/1 or /amounts/1.json
  def show
  end

  # GET /amounts/new
  def new
    @amount = Amount.new
  end

  # GET /amounts/1/edit
  def edit
  end

  # POST /amounts or /amounts.json
  def create
    @amount = Amount.new(amount_params)

    respond_to do |format|
      if @amount.save
        format.html { redirect_to @amount, notice: "Amount was successfully created." }
        format.json { render :show, status: :created, location: @amount }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @amount.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /amounts/1 or /amounts/1.json
  def update
    respond_to do |format|
      if @amount.update(amount_params)
        format.html { redirect_to @amount, notice: "Amount was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @amount }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @amount.errors, status: :unprocessable_entity }
      end
    end
  end

  # # DELETE /amounts/1 or /amounts/1.json
  # def destroy
  #   @amount.destroy!
  #
  #   respond_to do |format|
  #     format.html { redirect_to amounts_path, notice: "Amount was successfully destroyed.", status: :see_other }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_amount
      @amount = Amount.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def amount_params
      params.expect(amount: [ :ingredient_id, :serving, :serving_variant, :volume, :volume_variant, :weight ])
    end
end
