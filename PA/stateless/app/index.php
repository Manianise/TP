<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Cool</title>
  <!-- Bootstrap CSS -->
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body style="background-image:'url(admin.png)';background-size:contain;">
  <div class="container">
    <div class="row">
      <?php
      // Sample data
      $cardData = [
        ["title" => "Compteurs", "body" => "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer nec odio. Praesent libero. Sed cursus ante dapibus diam. Sed nisi."],
        ["title" => "Compteurs", "body" => "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer nec odio. Praesent libero. Sed cursus ante dapibus diam. Sed nisi."],
        ["title" => "Compteurs", "body" => "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer nec odio. Praesent libero. Sed cursus ante dapibus diam. Sed nisi."]
      ];

      // Loop through data and generate cards
      foreach ($cardData as $card) {
        ?>
        <div class="col-md-4">
          <div class="card">
            <div class="card-body">
              <h5 class="card-title"><?php echo $card['title']; ?></h5>
              <p class="card-text"><?php echo $card['body']; ?></p>
              <a href="#" class="btn btn-primary">Read More</a>
            </div>
          </div>
        </div>
        <?php
      }
      ?>
    </div>
  </div>

  <!-- Bootstrap JS (optional) -->
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
