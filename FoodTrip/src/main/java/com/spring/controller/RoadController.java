package com.spring.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;
import com.spring.domain.Marker;
import com.spring.domain.Road;
import com.spring.service.MarkerService;
import com.spring.service.RoadService;

@Controller
@RequestMapping("/road")
public class RoadController {
   
   private static final String cateChicken = "CK";
   private static final String cateChinese = "CH";
   private static final String catePasta = "PS";
   private static final String cateDisert = "DS";
   private static final String cateSnack = "SN";
   
   Gson g = new Gson();
   
   @Autowired
   private MarkerService markerService;
   
   @Autowired
   private RoadService roadService;
   

   
   @GetMapping("/home")
   public String roadhome() {
      return "roadhome";
   }

   //-------   CREATE   -------
   
   @GetMapping("/makeRoad")
   public String createRoad() {
      return "road/roadMake";
   }
   
   @PostMapping("/addCourse")
   @ResponseBody
   public String addCourse(@RequestBody Map<String, Object> map) {
      System.out.println("add Course IN");
      System.out.println(map);
      
      Road road = new Road();
      
      road.setCategory((String)map.get("category"));
      road.setUserNick((String)map.get("user"));
      road.setCourseSize((int)map.get("courseSize"));
      road.setDescription((String)map.get("description"));
      System.out.println("course size: "+road.getCourseSize());
      
      List<String> planlist = (List<String>)map.get("plan");
      String[] planary = planlist.toArray(new String[0]);
      
      road.setCourse(planary);
      
      System.out.println(road.getCourse()[1]);
      
      //ī�װ��� ���� id�ο� ����
      String getCate = road.getCategory();
      System.out.println(getCate);
      /*
         <option value="chicken">ġŲ</option>
         <option value="chinese">�߽�</option>
         <option value="pasta">�Ľ�Ÿ</option>
         <option value="snack">�н�</option>
         <option value=disert>����Ʈ</option>      
      */
      if(getCate.equals("chicken")) {
         road.setRoadId(cateChicken);
      }else if(getCate.equals("chinese")) {
         road.setRoadId(cateChinese);
      }else if(getCate.equals("pasta")) {
         road.setRoadId(catePasta);
      }else if(getCate.equals("snack")) {
         road.setRoadId(cateSnack);
      }else if(getCate.equals("disert")) {
         road.setRoadId(cateDisert);
      }

      roadService.roadCreate(road);
      
      return "success";
   }
   

   //-------   READ   -------
   //Road Read ALL
   @GetMapping("/readRoad")
   public String getAllRoad() {
      System.out.println("get all road IN");
      
      return "road/roadreadall";
   }


   //Road Read ALL
   @PostMapping("/readRoad")
   @ResponseBody
   public ResponseEntity<String> getAllRoadResult() {
      //���� ����� �ڽ� ������ ���� �����´�.
      List<Road> list = roadService.roadReadAll();
      System.out.println("readAll list get");
      System.out.println("list size : "+list.size());
      
      findMarker(list);
      
      //model.addAttribute("list", list);
      
      String listJson = g.toJson(list);
      System.out.println(listJson);

      HttpHeaders headers = new HttpHeaders();
      headers.setContentType(MediaType.APPLICATION_JSON);
      headers.set("Content-Type", "application/json; charset=UTF-8");
      
      return new ResponseEntity<>(listJson, headers, HttpStatus.OK);
   }
   
   //Read All Marker
   @GetMapping("/readMkAll")
   @ResponseBody
   public ResponseEntity<String> roadReadAll(Model model) {
      List<Marker> list = markerService.markerReadAll();
      
      String listJson = g.toJson(list);
      model.addAttribute(list);

      //�ѱ� ���� ����
      HttpHeaders headers = new HttpHeaders();
      headers.setContentType(MediaType.APPLICATION_JSON);
      headers.set("Content-Type", "application/json; charset=UTF-8");
      
      return new ResponseEntity<>(listJson, headers, HttpStatus.OK);
   }
   
   public void findMarker(List<Road> list){
      //�ڽ��� ���� ��Ŀid�� ��Ŀ�� ���� �����´�.
      //1. ����Ʈ�� ��ҿ� ����
      for(int i=0; i<list.size();i++) {
         ArrayList<Marker> find = new ArrayList<Marker>();
         Road roadOne = list.get(i);
         //System.out.println(roadOne.getCourse());
         String[] tmp = new String[roadOne.getCourseSize()];
         //2. ����Ʈ ��� �� ��Ŀ ����Ʈ�� ����
         //System.out.println("rd id in read " + roadOne.getRoadId());
         //System.out.println("rd size in read " + roadOne.getCourseSize());
         System.out.println("tmp size : "+tmp.length);
         for(int j=0; j<roadOne.getCourseSize(); j++) {
            tmp = roadOne.getCourse();   //�ּҰ��� ����.
            System.out.println("tmp in size : "+tmp.length);
            Marker mk = markerService.markerReadOne(tmp[j]);
            System.out.println(mk.getmarkerId());
            find.add(mk);
         }
         roadOne.setPoints(find);
      } 
   }
   
   public void findMarker(Road road) {
      ArrayList<Marker> find = new ArrayList<Marker>();
      Road roadOne = road;
      String[] tmp = new String[roadOne.getCourseSize()];
      //2. ����Ʈ ��� �� ��Ŀ ����Ʈ�� ����
      System.out.println("tmp size : "+tmp.length);
      for(int j=0; j<roadOne.getCourseSize(); j++) {
         tmp = roadOne.getCourse();   //�ּҰ��� ����.
         System.out.println("tmp in size : "+tmp.length);
         Marker mk = markerService.markerReadOne(tmp[j]);
         System.out.println(mk.getmarkerId());
         find.add(mk);
      }
      roadOne.setPoints(find);
   }
   
   //Road Read One
   @GetMapping("/roadUpdate")
   public String roadupdate(@RequestParam("id") String roadId, Model model) {
      System.out.println("���� : "+roadId);
      model.addAttribute("id", roadId);
      return "road/roadEditForm";
   }
   
   @PostMapping("/readOneRoad")
   @ResponseBody
   public ResponseEntity<String> oneRoad(@RequestBody String rid){
      System.out.println("�ϳ� �ٷ� ? : "+rid);
      String id = rid.replace('"', ' ');
      id = id.trim();
      System.out.println("�ٲ��ٷ�? : "+id);
      Road road = roadService.roadReadOne(id); 
      //������ �ε� �ϳ��� ��Ŀ ���� �Է�
      findMarker(road);
            
      String itemJson = g.toJson(road);
      
      System.out.println("������ �ϳ� : "+ itemJson);
      //�ѱ� ���� ����
      HttpHeaders headers = new HttpHeaders();
      headers.setContentType(MediaType.APPLICATION_JSON);
      headers.set("Content-Type", "application/json; charset=UTF-8");
      
      return new ResponseEntity<>(itemJson, headers, HttpStatus.OK);
   }

   //-------   UPDATE   -------

   @PostMapping("/roadUpExe")
   @ResponseBody
   public String roadUpdateExecute(@RequestBody Map<String, Object> map) {
      System.out.println("update IN : "+map);
      
      Road road = new Road();
      road.setRoadId((String)map.get("roadId"));
      road.setCategory((String)map.get("category"));
      road.setCourseSize((int)map.get("courseSize"));
      List<String> planlist = (List<String>)map.get("plan");
      String[] planary = planlist.toArray(new String[0]);
      road.setCourse(planary);
      System.out.println(road.getRoadId());
//      System.out.println(road.getCourseToString());
      roadService.roadUpdate(road);
      
      return "end"; 
   }
   //-------   DELETE   -------

   @GetMapping("/roadDelete")
   public String roaddelete(@RequestParam("id") String id) {
      System.out.println("������ id : "+id);
      
      roadService.roadDelete(id);      
      
      return "redirect:readRoad";
   }
}
