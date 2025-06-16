require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  test "render a list of products" do
    get products_path
    assert_response :success
    assert_select ".product", 12
    assert_select ".category", 9
  end
  test "render a list of products filtered by category" do
    get products_path(category_id: categories(:videogames).id)
    assert_response :success
    assert_select ".product", 7
  end
  test "render a list of products filtered by price" do
    get products_path(min_price: 160, max_price: 200)
    assert_response :success
    assert_select ".product", 3
    assert_select "h2", "Nintendo Switch"
  end
  test "render a list of products filtered by title" do
    get products_path(query_text: "switch")
    assert_response :success
    assert_select ".product", 1
    assert_select "h2", "Nintendo Switch"
  end
  test "sort products by expensive" do
    get products_path(order_by: "expensive")
    assert_response :success
    assert_select ".product", 12
    assert_select ".products .product:first-child h2", "Seat Panda clásico"
  end
  test "sort products by chepeast" do
    get products_path(order_by: "cheapest")
    assert_response :success
    assert_select ".product", 12
    assert_select ".products .product:first-child h2", "El hobbit"
  end
  test "sort products by newest" do
    get products_path(order_by: "newest")
    assert_response :success
    assert_select ".product", 12
    assert_select ".products .product:first-child h2", "Nintendo Switch"
  end
  test "render a detailed product page" do
    get product_path(products(:ps4))

    assert_response :success
    assert_select ".title", "PS4 Fat"
    assert_select ".price", "150$"
    assert_select ".description", "PS4 en buen estado"
  end

  test "render a form to create a new product" do
    get new_product_path

    assert_response :success
    assert_select "form" do
      assert_select "input[type=text]", 1
      assert_select "textarea", 1
      assert_select "input[type=number]", 1
      assert_select "input[type=submit]", 1
    end
  end

  test "allows to create a new product" do
    post products_path, params: {
      product: {
        title: "Nintendo 64",
        description: "Le faltan los cables",
        price: 45,
        category_id: categories(:videogames).id
      }
    }
    assert_redirected_to products_path
    assert_equal "Producto creado con éxito.", flash[:notice]
  end
  test "does not allow to create a new product with empty fields" do
    post products_path, params: {
      product: {
        title: "",
        description: "Le faltan los cables",
        price: 45,
        category_id: categories(:videogames).id
      }
    }
    assert_response :unprocessable_entity
  end
  test "render a form to edit a product" do
    get edit_product_path(products(:ps4))

    assert_response :success
    assert_select "form" do
      assert_select "input[type=text]", 1
      assert_select "textarea", 1
      assert_select "input[type=number]", 1
      assert_select "input[type=submit]", 1
    end
  end
  test "allows to update product" do
    patch product_path(products(:ps4)), params: {
      product: {
        price: 26
      }
    }
    assert_redirected_to products_path
    assert_equal "Producto actualizado con éxito.", flash[:notice]
  end

  test "Does not allows to update product" do
    patch product_path(products(:ps4)), params: {
      product: {
        price: nil
      }
    }
    assert_response :unprocessable_entity
  end
  test "can delete products" do
    assert_difference("Product.count", -1) do
      delete product_path(products(:ps4))
    end
    assert_redirected_to products_path
    assert_equal flash[:notice], "Producto eliminado con éxito."
  end
end
