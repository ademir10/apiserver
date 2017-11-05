require 'test_helper'

class DestinatariosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @destinatario = destinatarios(:one)
  end

  test "should get index" do
    get destinatarios_url
    assert_response :success
  end

  test "should get new" do
    get new_destinatario_url
    assert_response :success
  end

  test "should create destinatario" do
    assert_difference('Destinatario.count') do
      post destinatarios_url, params: { destinatario: { bairro: @destinatario.bairro, celular: @destinatario.celular, cidade: @destinatario.cidade, complemento: @destinatario.complemento, email: @destinatario.email, endereco: @destinatario.endereco, nome: @destinatario.nome, numero: @destinatario.numero, obs: @destinatario.obs } }
    end

    assert_redirected_to destinatario_url(Destinatario.last)
  end

  test "should show destinatario" do
    get destinatario_url(@destinatario)
    assert_response :success
  end

  test "should get edit" do
    get edit_destinatario_url(@destinatario)
    assert_response :success
  end

  test "should update destinatario" do
    patch destinatario_url(@destinatario), params: { destinatario: { bairro: @destinatario.bairro, celular: @destinatario.celular, cidade: @destinatario.cidade, complemento: @destinatario.complemento, email: @destinatario.email, endereco: @destinatario.endereco, nome: @destinatario.nome, numero: @destinatario.numero, obs: @destinatario.obs } }
    assert_redirected_to destinatario_url(@destinatario)
  end

  test "should destroy destinatario" do
    assert_difference('Destinatario.count', -1) do
      delete destinatario_url(@destinatario)
    end

    assert_redirected_to destinatarios_url
  end
end
