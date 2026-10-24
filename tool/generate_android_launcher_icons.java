import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.geom.RoundRectangle2D;
import java.awt.image.BufferedImage;
import java.io.File;
import javax.imageio.ImageIO;

/** Regenerates Android launcher bitmaps and the 512 px screenshot icon. */
public class generate_android_launcher_icons {
  public static void main(String[] args) throws Exception {
    String[] densities = {"mdpi", "hdpi", "xhdpi", "xxhdpi", "xxxhdpi"};
    int[] sizes = {48, 72, 96, 144, 192};

    for (int i = 0; i < densities.length; i++) {
      int size = sizes[i];
      BufferedImage image = renderIcon(size);

      File output = new File(
          "android/app/src/main/res/mipmap-" + densities[i] + "/ic_launcher.png");
      ImageIO.write(image, "png", output);
    }

    BufferedImage storeIcon = renderIcon(512);
    BufferedImage opaqueIcon = new BufferedImage(
        512, 512, BufferedImage.TYPE_INT_RGB);
    Graphics2D canvas = opaqueIcon.createGraphics();
    canvas.setColor(new Color(0x090E19));
    canvas.fillRect(0, 0, 512, 512);
    canvas.drawImage(storeIcon, 0, 0, null);
    canvas.dispose();
    ImageIO.write(opaqueIcon, "png", new File("screenshots/template-icon.png"));
  }

  private static BufferedImage renderIcon(int size) {
    BufferedImage image = new BufferedImage(
        size, size, BufferedImage.TYPE_INT_ARGB);
    Graphics2D canvas = image.createGraphics();
    canvas.setRenderingHint(
        RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
    canvas.scale(size / 48.0, size / 48.0);
    canvas.setColor(new Color(0x131D2D));
    canvas.fill(new RoundRectangle2D.Double(2, 2, 44, 44, 16, 16));
    canvas.setColor(new Color(0xE77860));
    canvas.fill(new RoundRectangle2D.Double(13, 13, 9, 9, 4, 4));
    canvas.setColor(new Color(0x19B8AA));
    canvas.fill(new RoundRectangle2D.Double(26, 13, 9, 9, 4, 4));
    canvas.setColor(new Color(0x8D78F6));
    canvas.fill(new RoundRectangle2D.Double(13, 26, 9, 9, 4, 4));
    canvas.setColor(new Color(0x2C9B76));
    canvas.fill(new RoundRectangle2D.Double(26, 26, 9, 9, 4, 4));
    canvas.dispose();
    return image;
  }
}
