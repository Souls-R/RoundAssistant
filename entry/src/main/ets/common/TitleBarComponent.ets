import router from '@ohos.router';

@Component
export struct TitleBar {
  private title: string | Resource = $r('app.string.title');
  private rightBtn: Resource = null;
  private handleRightBtn: () => void = null;

  build() {
    Row() {
      Text(this.title)
        .fontColor(Color.Black)
        .fontSize(24)
      Blank()

      if (this.rightBtn) {
        Image(this.rightBtn)
          .width(24)
          .height(24)
          .objectFit(ImageFit.Contain)
          .onClick(this.handleRightBtn)
      }
    }
    .width('100%')
    .height('8%')
    .constraintSize({ minHeight: 70 })
    .padding({ left: 10, right: 10 })
  }
}