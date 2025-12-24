<template>
  <div class="login-container">
    <el-card id="loginCard">
      <div>
        <el-row :gutter="20">
          <el-col :span="8">
            <img src="/pic/2233/22.png" alt="22" style="width: 150px; margin-left: -96px; margin-bottom: -391px">
          </el-col>
          <el-col @mouseover="change()" @mouseout="changeBack()" :span="8">
            <h3 style="font-weight: 540">扫描二维码登录</h3>
<!--            <vue-qrcode size="qrCodeSize" :value="qrCodeValue" v-show="flag"></vue-qrcode>-->
<!--            <img src="/pic/login/qr-tips.74063ae1.png" alt="客户端" style="height: 212px; margin-left: -75px" v-show="!flag">-->
            <div class="qr-container">
              <vue-qrcode :size="200" :value="qrCodeValue" v-show="flag"></vue-qrcode>
              <img src="/pic/login/qr-tips.74063ae1.png" alt="客户端" v-show="!flag">
            </div>
            <h4>请使用 <el-link type="primary" href="https://app.bilibili.com/">哔哩哔哩客户端</el-link></h4>
            <h4>扫码登录或扫码下载APP</h4>
          </el-col>
          <el-col :span="8">
            <img src="/pic/2233/33.png" alt="33" style="width: 150px; margin-right: -96px; margin-bottom: -391px">
          </el-col>
        </el-row>
      </div>
    </el-card>
  </div>

</template>

<script>

import axios from "axios";
import router from "@/router";
import {ElMessage} from "element-plus"

axios.defaults.timeout = 5000;
// 允许跨域
axios.defaults.withCredentials = true;
// Content-Type 响应头
axios.defaults.headers.post["Content-Type"] =
    "application/x-www-form-urlencoded;charset=UTF-8";
// 基础url
axios.defaults.baseURL = '/api'; //注意此处一定要和vite设置的请求名一致

export default {
  name: "Login",
  components: {},

  data(){
    return{
      qrCodeSize: 200,
      qrCodeValue: "",
      timer: null,
      qrcodekey: "",
      flag: true,
    };
  },
  mounted() {
    this.qrcodeGenerate();
  },
  beforeDestroy() {
    // 在组件销毁前清除定时器，防止内存泄漏
    clearInterval(this.timer);
  },
  methods: {
    qrcodeGenerate(){
      console.log("qrcodeGenerate()");
      axios.get("/getQRCode", {

      }).then(res => {
        this.qrCodeValue = res.data.data.data.url;
        this.qrcodekey = res.data.data.data.qrcode_key;
        console.log(this.qrCodeValue);
        this.timer = setInterval(this.verifyQrcode, 2000);
      })
    },
    verifyQrcode(){
      axios.get("/verifyQRCode?qrcodekey=" + this.qrcodekey, {

      }).then(res => {
        let scanStatus = res.data.code;
        console.log(scanStatus);
        if(scanStatus == "200"){
          clearInterval(this.timer);
          router.push("Index");
        }
      }).catch(error => {
        console.error("有哪里不对", error);
      })
    },
    change(){
      this.flag = false
    },
    changeBack(){
      this.flag = true
    }
  }
}
</script>

<style scoped>
.login-container {
  min-height: 100vh; /* 占满整个视口 */
  display: flex;
  align-items: center; /* 垂直居中 */
  justify-content: center; /* 水平居中 */
  background-color: white;
}
#loginCard {
  text-align: center;
  width: 700px;
  max-width: 90%; /* 小屏幕时不超出 */
  border-radius: 20px;
  overflow: hidden;
}

/* 固定二维码容器高度 */
.qr-container {
  height: 212px; /* 和提示图片高度一致 */
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 10px 0;
}

.qr-container img {
  max-height: 100%;
  width: auto;
}


h3{
  color: #808080;
}
h4{
  color: #808080;
}
</style>