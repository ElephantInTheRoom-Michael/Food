class StoresController < ApplicationController
  before_action :set_store, only: %i[ show edit update shopping_trip shopping_trip_update ] # destroy ]

  # GET /stores or /stores.json
  def index
    @stores = Store.all
  end

  # GET /stores/1 or /stores/1.json
  def show
  end

  # GET /stores/new
  def new
    @store = Store.new
  end

  # GET /stores/1/edit
  def edit
  end

  # GET /stores/1/shopping_trip
  def shopping_trip
    10.times { @store.prices.build }
  end

  # POST /stores or /stores.json
  def create
    @store = Store.new(store_params)

    respond_to do |format|
      if @store.save
        format.html { redirect_to @store, notice: "Store was successfully created." }
        format.json { render :show, status: :created, location: @store }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stores/1 or /stores/1.json
  def update
    respond_to do |format|
      if @store.update(store_params)
        format.html { redirect_to @store, notice: "Store was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @store }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stores/1/shopping_trip or /stores/1/shopping_trip.json
  def shopping_trip_update
    respond_to do |format|
      if @store.update(shopping_trip_params)
        format.html { redirect_to @store, notice: "Shopping trip was successfully added.", status: :see_other }
        format.json { render :show, status: :ok, location: @store }
      else
        format.html { render :shopping_trip, status: :unprocessable_entity }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # # DELETE /stores/1 or /stores/1.json
  # def destroy
  #   @store.destroy!
  #
  #   respond_to do |format|
  #     format.html { redirect_to stores_path, notice: "Store was successfully destroyed.", status: :see_other }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_store
      @store = Store.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def store_params
      params.expect(store: [ :name ])
    end

  def shopping_trip_params
    params.expect(
      store: [
        :name,
        :date,
        prices_attributes: [ [ :ingredient_id, :description, :amount_id, :brand_id, :sale, :price ] ],
      ]
    ).tap do |params|
      if params.has_key?(:date)
        params[:prices_attributes].each_value do |price_params|
          price_params[:date] = params[:date]
        end
        params.delete(:date)
      end
    end
  end
end
