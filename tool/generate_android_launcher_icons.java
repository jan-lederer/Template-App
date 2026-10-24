import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.geom.Ellipse2D;
import java.awt.geom.RoundRectangle2D;
import java.awt.image.BufferedImage;
import java.io.File;
import javax.imageio.ImageIO;

/** Regenerates the multicolor launcher bitmaps to match ic_launcher.xml. */
public class generate_android_launcher_icons {
  public static void main(String[] args) throws Exception {
    String[] densities = {"mdpi", "hdpi", "xhdpi", "xxhdpi", "xxxhdpi"};
    int[] sizes = {48, 72, 96, 144, 192};

    for (int i = 0; i < densities.length; i++) {
      int size = sizes[i];
      BufferedImage image = new BufferedImage(
          size, size, BufferedImage.TYPE_INT_ARGB);
      Graphics2D canvas = image.createGraphics();
      canvas.setRenderingHint(
          RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
      canvas.scale(size / 48.0, size / 48.0);
      canvas.setColor(new Color(0x131D2D));
      canvas.fill(new RoundRectangle2D.Double(2, 2, 44, 44, 16, 16));
      canvas.setColor(new Color(0xE77860));
      canvas.fill(new Ellipse2D.Double(13, 20.5, 7, 7));
      canvas.setColor(new Color(0x19B8AA));
      canvas.fill(new RoundRectangle2D.Double(25, 22, 5, 4, 4, 4));
      canvas.fill(new java.awt.geom.Rectangle2D.Double(27, 22, 3, 4));
      canvas.setColor(new Color(0x8D78F6));
      canvas.fill(new RoundRectangle2D.Double(30, 22, 5, 4, 4, 4));
      canvas.fill(new java.awt.geom.Rectangle2D.Double(30, 22, 3, 4));
      canvas.dispose();

      File output = new File(
          "android/app/src/main/res/mipmap-" + densities[i] + "/ic_launcher.png");
      ImageIO.write(image, "png", output);
    }
  }
}
