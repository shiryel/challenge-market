defmodule MarketWeb.Schema.BottlerTest do
  use MarketWeb.ConnCase, async: true

  setup do
    Code.eval_file("priv/repo/seeds.exs")

    :ok
  end

  def build_authenticated_conn() do
    mutation = """
      mutation {
        login(email: "vinicius@hotmail.com", password: "test") {
          token
        } 
      }
    """

    response =
      post(build_conn(), "/api", %{
        query: mutation
      })

    token = json_response(response, 200)["data"]["login"]["token"]

    build_conn() |> put_req_header("authorization", "Bearer #{token}")
  end

  describe "pagination" do
    @pair_query """
    query($page: Int!, $pageSize: Int!) {
      me {
        providers(page: 1, pageSize: 1, filterNames: ["CBOE"]) {
          name
    			pairs(page: $page, pageSize: $pageSize) {
            name
          }
        }
      }
    }
    """

    @providers_query """
    query($page: Int!, $pageSize: Int!) {
      me {
        providers(page: $page, pageSize: $pageSize, filterNames: ["CBOE"]) {
          name
        }
      }
    }
    """

    test "pairs page 1 with size 2" do
      response =
        post(build_authenticated_conn(), "/api", %{
          query: @pair_query,
          variables: %{"page" => 1, "pageSize" => 2}
        })

      assert %{
               "data" => %{
                 "me" => %{
                   "providers" => [
                     %{
                       "name" => "CBOE",
                       "pairs" => [%{"name" => "EUR/GBP"}, %{"name" => "EUR/USD"}]
                     }
                   ]
                 }
               }
             } = json_response(response, 200)
    end

    test "pairs page 2 with size 2" do
      response =
        post(build_authenticated_conn(), "/api", %{
          query: @pair_query,
          variables: %{"page" => 2, "pageSize" => 2}
        })

      assert %{
               "data" => %{
                 "me" => %{
                   "providers" => [
                     %{
                       "name" => "CBOE",
                       "pairs" => [%{"name" => "EUR/USD"}, %{"name" => "GBP/USD"}]
                     }
                   ]
                 }
               }
             } = json_response(response, 200)
    end

    test "pairs page 0 with size 3 will default to page 1" do
      response =
        post(build_authenticated_conn(), "/api", %{
          query: @pair_query,
          variables: %{"page" => 0, "pageSize" => 3}
        })

      assert %{
               "data" => %{
                 "me" => %{
                   "providers" => [
                     %{
                       "name" => "CBOE",
                       "pairs" => [
                         %{"name" => "EUR/GBP"},
                         %{"name" => "EUR/USD"},
                         %{"name" => "GBP/USD"}
                       ]
                     }
                   ]
                 }
               }
             } = json_response(response, 200)
    end

    test "pairs page -2 with size 3 will default to page 1" do
      response =
        post(build_authenticated_conn(), "/api", %{
          query: @pair_query,
          variables: %{"page" => -2, "pageSize" => 3}
        })

      assert %{
               "data" => %{
                 "me" => %{
                   "providers" => [
                     %{
                       "name" => "CBOE",
                       "pairs" => [
                         %{"name" => "EUR/GBP"},
                         %{"name" => "EUR/USD"},
                         %{"name" => "GBP/USD"}
                       ]
                     }
                   ]
                 }
               }
             } = json_response(response, 200)
    end

    test "pairs page 1 with size -100 will default to size 50" do
      response =
        post(build_authenticated_conn(), "/api", %{
          query: @pair_query,
          variables: %{"page" => 0, "pageSize" => -100}
        })

      assert %{
               "data" => %{
                 "me" => %{
                   "providers" => [
                     %{
                       "name" => "CBOE",
                       "pairs" => [
                         %{"name" => "EUR/GBP"},
                         %{"name" => "EUR/USD"},
                         %{"name" => "GBP/USD"}
                       ]
                     }
                   ]
                 }
               }
             } = json_response(response, 200)
    end

    test "providers page 1 with size 0" do
      response =
        post(build_authenticated_conn(), "/api", %{
          query: @providers_query,
          variables: %{"page" => 1, "pageSize" => 0}
        })

      assert %{"data" => %{"me" => %{"providers" => []}}} = json_response(response, 200)
    end
  end

  describe "filterNames" do
    @pair_query """
    query($filterNames: [String!]) {
      me {
        providers(filterNames: ["CBOE"]) {
          name
    			pairs(filterNames: $filterNames) {
            name
          }
        }
      }
    }
    """

    @providers_query """
    query($filterNames: [String!]) {
      me {
        providers(filterNames: $filterNames) {
          name
        }
      }
    }
    """

    test "Pairs can filter 2 names" do
      response =
        post(build_authenticated_conn(), "/api", %{
          query: @pair_query,
          variables: %{"filterNames" => ["EUR/GBP", "GBP/USD"]}
        })

      assert %{
               "data" => %{
                 "me" => %{
                   "providers" => [
                     %{
                       "name" => "CBOE",
                       "pairs" => [%{"name" => "EUR/GBP"}, %{"name" => "GBP/USD"}]
                     }
                   ]
                 }
               }
             } = json_response(response, 200)
    end

    test "Pairs can filter 1 name" do
      response =
        post(build_authenticated_conn(), "/api", %{
          query: @pair_query,
          variables: %{"filterNames" => ["GBP/USD"]}
        })

      assert %{
               "data" => %{
                 "me" => %{
                   "providers" => [
                     %{
                       "name" => "CBOE",
                       "pairs" => [%{"name" => "GBP/USD"}]
                     }
                   ]
                 }
               }
             } = json_response(response, 200)
    end

    test "Pairs can filter 0 name" do
      response =
        post(build_authenticated_conn(), "/api", %{
          query: @pair_query,
          variables: %{"filterNames" => []}
        })

      assert %{
               "data" => %{
                 "me" => %{
                   "providers" => [
                     %{
                       "name" => "CBOE",
                       "pairs" => []
                     }
                   ]
                 }
               }
             } = json_response(response, 200)
    end

    test "Providers can filter 0 name" do
      response =
        post(build_authenticated_conn(), "/api", %{
          query: @providers_query,
          variables: %{"filterNames" => []}
        })

      assert %{
               "data" => %{
                 "me" => %{
                   "providers" => []
                 }
               }
             } = json_response(response, 200)
    end
  end

  describe "bottlers filter" do
    @bottlers_query """
    query($filter: BottlerFilter!) {
      me {
        providers(filterNames: ["CBOE"]) {
          name
    			pairs(filterNames: ["EUR/GBP"]) {
            name
            bottlers(filter: $filter) {
              date
              price
              quantity
            }
          }
        }
      }
    }
    """

    test "can filter by price min" do
      response =
        post(build_authenticated_conn(), "/api", %{
          query: @bottlers_query,
          variables: %{"filter" => %{priceMin: 50_000}}
        })

      assert %{
               "data" => %{
                 "me" => %{
                   "providers" => [
                     %{
                       "name" => "CBOE",
                       "pairs" => [
                         %{
                           "bottlers" => [
                             %{
                               "price" => "50000",
                               "quantity" => 50_000
                             }
                           ],
                           "name" => "EUR/GBP"
                         }
                       ]
                     }
                   ]
                 }
               }
             } = json_response(response, 200)
    end

    test "can filter by price max" do
      response =
        post(build_authenticated_conn(), "/api", %{
          query: @bottlers_query,
          variables: %{"filter" => %{priceMax: 5000}}
        })

      assert %{
               "data" => %{
                 "me" => %{
                   "providers" => [
                     %{
                       "name" => "CBOE",
                       "pairs" => [
                         %{
                           "bottlers" => [
                             %{
                               "price" => "1000",
                               "quantity" => 1000
                             },
                             %{
                               "price" => "2000",
                               "quantity" => 2000
                             },
                             %{
                               "price" => "3000",
                               "quantity" => 3000
                             },
                             %{
                               "price" => "4000",
                               "quantity" => 4000
                             },
                             %{
                               "price" => "5000",
                               "quantity" => 5000
                             }
                           ],
                           "name" => "EUR/GBP"
                         }
                       ]
                     }
                   ]
                 }
               }
             } = json_response(response, 200)
    end

    test "can filter by quantity min" do
      response =
        post(build_authenticated_conn(), "/api", %{
          query: @bottlers_query,
          variables: %{"filter" => %{quantityMin: 50_000}}
        })

      assert %{
               "data" => %{
                 "me" => %{
                   "providers" => [
                     %{
                       "name" => "CBOE",
                       "pairs" => [
                         %{
                           "bottlers" => [
                             %{
                               "price" => "50000",
                               "quantity" => 50_000
                             }
                           ],
                           "name" => "EUR/GBP"
                         }
                       ]
                     }
                   ]
                 }
               }
             } = json_response(response, 200)
    end

    test "can filter by quantity max" do
      response =
        post(build_authenticated_conn(), "/api", %{
          query: @bottlers_query,
          variables: %{"filter" => %{quantityMax: 3000}}
        })

      assert %{
               "data" => %{
                 "me" => %{
                   "providers" => [
                     %{
                       "name" => "CBOE",
                       "pairs" => [
                         %{
                           "bottlers" => [
                             %{
                               "price" => "1000",
                               "quantity" => 1000
                             },
                             %{
                               "price" => "2000",
                               "quantity" => 2000
                             },
                             %{
                               "price" => "3000",
                               "quantity" => 3000
                             }
                           ],
                           "name" => "EUR/GBP"
                         }
                       ]
                     }
                   ]
                 }
               }
             } = json_response(response, 200)
    end

    test "can filter by date start" do
      response =
        post(build_authenticated_conn(), "/api", %{
          query: @bottlers_query,
          variables: %{
            "filter" => %{
              dateStart: DateTime.add(DateTime.utc_now(), -50_000, :second) |> DateTime.to_string()
            }
          }
        })

      assert %{
               "data" => %{
                 "me" => %{
                   "providers" => [
                     %{
                       "name" => "CBOE",
                       "pairs" => [
                         %{
                           "bottlers" => [
                             %{
                               "price" => "1000",
                               "quantity" => 1000
                             },
                             %{
                               "price" => "2000",
                               "quantity" => 2000
                             },
                             %{
                               "price" => "3000",
                               "quantity" => 3000
                             },
                             %{
                               "price" => "4000",
                               "quantity" => 4000
                             },
                             %{
                               "price" => "5000",
                               "quantity" => 5000
                             }
                           ],
                           "name" => "EUR/GBP"
                         }
                       ]
                     }
                   ]
                 }
               }
             } = json_response(response, 200)
    end

    test "can filter by date end" do
      response =
        post(build_authenticated_conn(), "/api", %{
          query: @bottlers_query,
          variables: %{
            "filter" => %{
              dateEnd: DateTime.add(DateTime.utc_now(), -500_000, :second) |> DateTime.to_string()
            }
          }
        })

      assert %{
               "data" => %{
                 "me" => %{
                   "providers" => [
                     %{
                       "name" => "CBOE",
                       "pairs" => [
                         %{
                           "bottlers" => [
                             %{
                               "price" => "50000",
                               "quantity" => 50_000
                             }
                           ],
                           "name" => "EUR/GBP"
                         }
                       ]
                     }
                   ]
                 }
               }
             } = json_response(response, 200)
    end
  end
end
