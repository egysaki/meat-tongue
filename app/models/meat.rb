class Meat < ApplicationRecord

  def return_contents
    hero = {
      "type": "image",
      "url": image_path,
      "size": "full",
      "aspectRatio": "20:13",
      "aspectMode": "cover"
    }

    body = {
      "type": "box",
      "layout": "vertical",
      "contents": [
        {
          "type": "text",
          "text": name,
          "weight": "bold",
          "size": "xl"
        },
        {
          "type": "box",
          "layout": "vertical",
          "margin": "lg",
          "spacing": "sm",
          "contents": [
            {
              "type": "box",
              "layout": "baseline",
              "spacing": "sm",
              "contents": [
                {
                  "type": "text",
                  "text": "解説",
                  "size": "md",
                  "weight": "bold",
                  "flex": 1
                },
                {
                  "type": "text",
                  "text": description,
                  "wrap": true,
                  "size": "sm",
                  "flex": 5
                }
              ]
            }
          ]
        }
      ]
    }

    contents = {
      "type": "bubble",
      "hero": hero,
      "body": body
    }
  end

end
