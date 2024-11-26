<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Swagger UI</title>
    <link rel="stylesheet" type="text/css" href="<?php echo e(asset('swagger-ui/swagger-ui.css')); ?>">
    <style>
        html { box-sizing: border-box; overflow: -moz-scrollbars-vertical; overflow-y: scroll; }
        *, *:before, *:after { box-sizing: inherit; }
        body { margin:0; background: #fafafa; }
    </style>
</head>
<body>
    <div id="swagger-ui"></div>
    <script src="<?php echo e(asset('swagger-ui/swagger-ui-bundle.js')); ?>"> </script>
    <script src="<?php echo e(asset('swagger-ui/swagger-ui-standalone-preset.js')); ?>"> </script>
    <script>
        window.onload = function() {
            const ui = SwaggerUIBundle({
                url: "<?php echo e(url('/swagger-docs/openapi.yaml')); ?>",
                dom_id: '#swagger-ui',
                presets: [
                    SwaggerUIBundle.presets.apis,
                    SwaggerUIStandalonePreset
                ],
                layout: "StandaloneLayout"
            });
            window.ui = ui;
        }
    </script>
</body>
</html>
<?php /**PATH C:\Users\sarah\Desktop\api_eloquent\tripulante-api\resources\views/swagger-ui.blade.php ENDPATH**/ ?>